import 'dart:async';
import 'package:flutter/material.dart';

// ViewModel untuk mengelola data dan state Timer
class Timerviewmodel with ChangeNotifier {
  late Timer _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  int _currentCycle = 1;
  bool _isWorkPhase = true;
  bool _isRunning = false;
  double _workDuration = 25.0;
  double _breakDuration = 5.0;
  int _cycles = 4;

  // Callbacks
  VoidCallback? _onPhaseComplete;
  VoidCallback? _onAllCyclesComplete;

  // Getters
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  int get currentCycle => _currentCycle;
  bool get isWorkPhase => _isWorkPhase;
  bool get isRunning => _isRunning;
  double get workDuration => _workDuration;
  double get breakDuration => _breakDuration;
  int get cycles => _cycles;
  String get formattedTime => _formatTime(_remainingSeconds);
  double get progress => _getProgress();

  // Setters
  void setWorkDuration(double value) {
    _workDuration = value;
    notifyListeners();
  }

  void setBreakDuration(double value) {
    _breakDuration = value;
    notifyListeners();
  }

  void setCycles(int value) {
    _cycles = value;
    notifyListeners();
  }

  void setPhaseCompleteCallback(VoidCallback callback) {
    _onPhaseComplete = callback;
  }

  void setAllCyclesCompleteCallback(VoidCallback callback) {
    _onAllCyclesComplete = callback;
  }

  // Initialize timer with durations
  void initialize(double workDuration, double breakDuration, int cycles) {
    _workDuration = workDuration;
    _breakDuration = breakDuration;
    _cycles = cycles;
    _remainingSeconds = 0;
    _totalSeconds = 0;
    _currentCycle = 1;
    _isWorkPhase = true;
    _isRunning = false;
    _startPhase();
  }

  void _startPhase() {
    _totalSeconds = _isWorkPhase
        ? (_workDuration * 60).toInt()
        : (_breakDuration * 60).toInt();
    _remainingSeconds = _totalSeconds;
    _startTimer();
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer.cancel();
        _isRunning = false;
        _showPhaseComplete();
        notifyListeners();
      }
    });
  }

  void pauseTimer() {
    if (_isRunning) {
      _timer.cancel();
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
    _timer.cancel();
    _isRunning = false;
    _moveToNextPhase();
    notifyListeners();
  }

  void _showPhaseComplete() {
    if (_isWorkPhase) {
      _isWorkPhase = false;
      _onPhaseComplete?.call();
    } else {
      _moveToNextPhase();
    }
  }

  void _moveToNextPhase() {
    if (_isWorkPhase) {
      _isWorkPhase = false;
      _showPhaseComplete();
    } else {
      if (_currentCycle < _cycles) {
        _currentCycle++;
        _isWorkPhase = true;
        _startPhase();
      } else {
        // All cycles complete
        // notify listener that all cycles are complete (UI can pop)
        _onAllCyclesComplete?.call();
        resetTimer();
      }
    }
    notifyListeners();
  }

  void moveToNextPhaseFromDialog() {
    _moveToNextPhase();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    return _totalSeconds > 0
        ? (_totalSeconds - _remainingSeconds) / _totalSeconds
        : 0;
  }

  void resetTimer() {
    _remainingSeconds = 0;
    _totalSeconds = 0;
    _currentCycle = 1;
    _isWorkPhase = true;
    _isRunning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
  }
}
