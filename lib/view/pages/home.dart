part of 'pages.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Configuration State
  double _workDuration = 25;
  double _breakDuration = 5;

  // Timer State
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;
  bool _isWorkMode = true; // true = Work, false = Break

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  // --- Timer Logic ---

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _stopTimer();
        // Optional: Play a sound here
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      // Set time based on current mode
      int minutes = _isWorkMode
          ? _workDuration.round()
          : _breakDuration.round();
      _remainingSeconds = minutes * 60;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _toggleMode() {
    setState(() {
      _isWorkMode = !_isWorkMode;
      _resetTimer(); // Reset time to the new mode's duration
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Color get _themeColor => _isWorkMode ? Colors.deepOrange : Colors.teal;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isWorkMode ? Colors.deepOrange[50] : Colors.teal[50],
      appBar: AppBar(
        title: Text(_isWorkMode ? "Work Timer" : "Break Timer"),
        backgroundColor: _themeColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isWorkMode ? Icons.coffee : Icons.work),
            tooltip: "Switch Mode",
            onPressed: _toggleMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Timer Display
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _themeColor, width: 4),
                  color: Colors.white,
                ),
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: _themeColor,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    label: Text(_isRunning ? "Pause" : "Start"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    label: const Text("Reset"),
                  ),
                ],
              ),

              const SizedBox(height: 50),
              const Divider(),
              const SizedBox(height: 10),

              // Sliders Configuration
              const Text(
                "Timer Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Work Duration Slider
              _buildSlider(
                label: "Work Duration",
                value: _workDuration,
                min: 5,
                max: 60,
                activeColor: Colors.deepOrange,
                onChanged: (val) {
                  setState(() {
                    _workDuration = val;
                    if (_isWorkMode && !_isRunning) {
                      _remainingSeconds = (_workDuration * 60).round();
                    }
                  });
                },
              ),

              // Break Duration Slider
              _buildSlider(
                label: "Break Duration",
                value: _breakDuration,
                min: 1,
                max: 30,
                activeColor: Colors.teal,
                onChanged: (val) {
                  setState(() {
                    _breakDuration = val;
                    if (!_isWorkMode && !_isRunning) {
                      _remainingSeconds = (_breakDuration * 60).round();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Color activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${value.round()} min",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: activeColor,
          label: value.round().toString(),
          onChanged: _isRunning
              ? null
              : onChanged, // Disable slider while timer is running
        ),
      ],
    );
  }
}
