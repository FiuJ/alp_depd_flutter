part of 'pages.dart';

class TimerPage extends StatefulWidget {
  final double workDuration;
  final double breakDuration;
  final int cycles;

  const TimerPage({
    super.key,
    required this.workDuration,
    required this.breakDuration,
    required this.cycles,
  });

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Timerviewmodel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Timerviewmodel();
    _viewModel.setPhaseCompleteCallback(_showPhaseCompleteDialog);
    _viewModel.initialize(
      widget.workDuration,
      widget.breakDuration,
      widget.cycles,
    );
  }

  void _showPhaseCompleteDialog() {
    if (_viewModel.isWorkPhase) {
      // Work phase complete - show break in popup
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _BreakDialog(
          viewModel: _viewModel,
          onContinue: () {
            _viewModel.moveToNextPhaseFromDialog();
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Style.background,
        child: Column(
          children: [
            // Top content - centered
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Phase indicator
                  Text(
                    _viewModel.isWorkPhase ? 'Work' : 'Break',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Style.orange,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Cycle indicator
                  Text(
                    'Cycle ${_viewModel.currentCycle} of ${_viewModel.cycles}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  // Circular progress bar
                  Center(
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Progress outline circle
                          SizedBox(
                            width: 280,
                            height: 280,
                            child: CircularProgressIndicator(
                              value: _viewModel.progress,
                              strokeWidth: 8,
                              strokeCap: StrokeCap.round,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _viewModel.isWorkPhase
                                    ? Style.orange
                                    : Colors.green,
                              ),
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                          // Center content - timer display and buttons
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_viewModel.isWorkPhase) ...[
                                Text(
                                  _viewModel.formattedTime,
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: Style.textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Work Time',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                              // Control buttons inside circle
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: _viewModel.isRunning
                                        ? _viewModel.pauseTimer
                                        : _viewModel.resumeTimer,
                                    backgroundColor: Style.orange,
                                    child: Icon(
                                      _viewModel.isRunning
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: () {
                                      if (_viewModel.isWorkPhase) {
                                        // During work - show break dialog
                                        _viewModel.pauseTimer();
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => _BreakDialog(
                                            viewModel: _viewModel,
                                            onContinue: () {
                                              _viewModel
                                                  .moveToNextPhaseFromDialog();
                                            },
                                          ),
                                        );
                                      } else {
                                        // During break - skip to next phase
                                        _viewModel.skipPhase();
                                      }
                                    },
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.skip_next,
                                      color: Style.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom image
            SvgPicture.asset('assets/images/yuccawork.svg', height: 350),
          ],
        ),
      ),
    );
  }
}

class _BreakDialog extends StatefulWidget {
  final Timerviewmodel viewModel;
  final VoidCallback onContinue;

  const _BreakDialog({required this.viewModel, required this.onContinue});

  @override
  State<_BreakDialog> createState() => _BreakDialogState();
}

class _BreakDialogState extends State<_BreakDialog> {
  late Timer _breakTimer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = (widget.viewModel.breakDuration * 60).toInt();
    _startBreakTimer();
  }

  void _startBreakTimer() {
    _breakTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _breakTimer.cancel();
          Navigator.pop(context);
          widget.onContinue();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _breakTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Time to Break!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Cycle ${widget.viewModel.currentCycle} of ${widget.viewModel.cycles}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Text(
            _formatTime(_remainingSeconds),
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Style.orange,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Break Time',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Style.orange),
          onPressed: () {
            _breakTimer.cancel();
            Navigator.pop(context);
            widget.onContinue();
          },
          child: const Text(
            'Skip Break',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
