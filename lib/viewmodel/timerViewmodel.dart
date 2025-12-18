import 'dart:async';
import 'package:flutter/material.dart';
import '../model/assignmentModel.dart';
import '../repository/assignmentRepository.dart';

class Timerviewmodel with ChangeNotifier {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  int _currentCycle = 1;
  bool _isWorkPhase = true;
  bool _isRunning = false;

  double _workDuration = 25.0;
  double _breakDuration = 5.0;
  int _cycles = 4;

  final AssignmentRepository _repository = AssignmentRepository();
  final List<Assignment> _selectedAssignments = [];

  VoidCallback? _onPhaseComplete;
  VoidCallback? _onAllCyclesComplete;

  // --- Getters ---
  double get workDuration => _workDuration;
  double get breakDuration => _breakDuration;
  int get remainingSeconds => _remainingSeconds;
  int get currentCycle => _currentCycle;
  int get cycles => _cycles;
  bool get isWorkPhase => _isWorkPhase;
  bool get isRunning => _isRunning;
  String get formattedTime => _formatTime(_remainingSeconds);
  double get progress => _totalSeconds > 0
      ? (_totalSeconds - _remainingSeconds) / _totalSeconds
      : 0;
  List<Assignment> get selectedAssignments => _selectedAssignments;

  // --- Selection Logic ---
  void toggleSelection(Assignment assignment) {
    final index = _selectedAssignments.indexWhere((a) => a.id == assignment.id);
    if (index != -1) {
      _selectedAssignments.removeAt(index);
    } else {
      _selectedAssignments.add(assignment);
    }
    notifyListeners();
  }

  bool isSelected(String id) => _selectedAssignments.any((a) => a.id == id);

  void setPhaseCompleteCallback(VoidCallback callback) =>
      _onPhaseComplete = callback;
  void setAllCyclesCompleteCallback(VoidCallback callback) =>
      _onAllCyclesComplete = callback;

  // --- Timer Logic ---

  void initialize(double workDuration, double breakDuration, int cycles) {
    _workDuration = workDuration;
    _breakDuration = breakDuration;
    _cycles = cycles;
    _currentCycle = 1;
    _isWorkPhase = true;
    _isRunning = false;

    // Prepare the first Work session time immediately
    _totalSeconds = (_workDuration * 60).toInt();
    _remainingSeconds = _totalSeconds;
    notifyListeners();
  }

  void _startPhase() {
    _totalSeconds =
        (_isWorkPhase ? _workDuration : _breakDuration).toInt() * 60;
    _remainingSeconds = _totalSeconds;
    _startTimer();
  }

  void _startTimer() {
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        _handlePhaseEnd();
      }
    });
  }

  void _handlePhaseEnd() {
    _timer?.cancel();
    _isRunning = false;

    if (_isWorkPhase) {
      _isWorkPhase = false;

      // FIX: Set the break time BEFORE calling the dialog so the UI is ready
      _totalSeconds = (_breakDuration * 60).toInt();
      _remainingSeconds = _totalSeconds;

      notifyListeners();
      _onPhaseComplete?.call();
    } else {
      _moveToNextPhase();
    }
  }

  void _moveToNextPhase() {
    if (_currentCycle < _cycles) {
      _currentCycle++;
      _isWorkPhase = true;
      _startPhase();
    } else {
      _isRunning = false;
      _timer?.cancel();
      _onAllCyclesComplete?.call();
    }
    notifyListeners();
  }

  void moveToNextPhaseFromDialog() {
    _startPhase(); // Starts the break or next work session
  }

  void pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      notifyListeners();
    }
  }

  void resumeTimer() {
    if (!_isRunning && _remainingSeconds > 0) {
      _startTimer();
    }
  }

  void skipPhase() {
    _timer?.cancel();
    _isRunning = false;
    _handlePhaseEnd();
  }

  void resetTimer() {
    _timer?.cancel();
    _remainingSeconds = 0;
    _totalSeconds = 0;
    _currentCycle = 1;
    _isWorkPhase = true;
    _isRunning = false;
    notifyListeners();
  }

  // --- Database Interaction ---

  Future<void> finalizeSession(Map<String, double> progressUpdates) async {
    if (progressUpdates.isNotEmpty) {
      // FIX: Ensure lowercase 'int' is used for DB compatibility
      final Map<String, int> finalData = progressUpdates.map(
        (key, value) => MapEntry(key, value.toInt()),
      );

      await _repository.updateBulkProgress(finalData);
    }

    _selectedAssignments.clear();
    resetTimer();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
