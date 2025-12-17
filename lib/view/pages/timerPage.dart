part of 'pages.dart';

class TimerPage extends StatefulWidget {
  final double workDuration;
  final double breakDuration;
  final int cycles;

  // Note: Removed assignmentName and initialProgress as they are now
  // managed via the ViewModel's selection list.
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
    // Assuming you are using a provider or a singleton.
    // If not, ensure the ViewModel instance is the same one used in the selection page.
    _viewModel = Timerviewmodel();

    _viewModel.setPhaseCompleteCallback(_showPhaseCompleteDialog);

    _viewModel.setAllCyclesCompleteCallback(() async {
      if (mounted) {
        // Show progress update if the user actually picked assignments
        if (_viewModel.selectedAssignments.isNotEmpty) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ProgressUpdateDialog(
              assignments: _viewModel.selectedAssignments,
              onSave: (progressUpdates) async {
                await _viewModel.finalizeSession(progressUpdates);
                if (mounted) {
                  Navigator.pop(context); // Close Dialog
                  Navigator.pop(context); // Return to Settings
                }
              },
            ),
          );
        } else {
          // If no assignments selected, just exit
          Navigator.pop(context);
        }
      }
    });

    _viewModel.initialize(
      widget.workDuration,
      widget.breakDuration,
      widget.cycles,
    );
  }

  void _showPhaseCompleteDialog() {
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

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            color: Style.background,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Phase indicator (Work/Break)
                      Text(
                        _viewModel.isWorkPhase ? 'Work' : 'Break',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Style.orange,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Cycle counter
                      Text(
                        'Cycle ${_viewModel.currentCycle} of ${_viewModel.cycles}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // NEW: Selected Assignments Display
                      if (_viewModel.selectedAssignments.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "Focusing on: ${_viewModel.selectedAssignments.map((e) => e.title).join(", ")}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Style.textColor.withOpacity(0.7),
                            ),
                          ),
                        ),

                      const SizedBox(height: 40),

                      // Circular Progress Bar
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _viewModel.formattedTime,
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: Style.textColor,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FloatingActionButton(
                                      mini: true,
                                      elevation: 2,
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
                                      elevation: 2,
                                      onPressed: () => _viewModel.skipPhase(),
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
                    ],
                  ),
                ),
                // Decorative Image
                SvgPicture.asset('assets/images/YuccaWork.svg', height: 300),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- Break Dialog ---
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
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _breakTimer.cancel();
            Navigator.pop(context);
            widget.onContinue();
          }
        });
      }
    });
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
            '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Style.orange,
            ),
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

// --- Progress Update Dialog ---
class ProgressUpdateDialog extends StatefulWidget {
  final List<Assignment> assignments;
  final Function(Map<String, double>) onSave;

  const ProgressUpdateDialog({
    super.key,
    required this.assignments,
    required this.onSave,
  });

  @override
  State<ProgressUpdateDialog> createState() => _ProgressUpdateDialogState();
}

class _ProgressUpdateDialogState extends State<ProgressUpdateDialog> {
  late Map<String, double> _localProgress;

  @override
  void initState() {
    super.initState();
    // Pre-populate with current progress from the model
    _localProgress = {for (var a in widget.assignments) a.id: a.progress};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update Progress"),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.assignments.map((a) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _localProgress[a.id]!,
                    min: 0,
                    max: 100,
                    activeColor: Style.orange,
                    label: "${_localProgress[a.id]!.round()}%",
                    onChanged: (val) =>
                        setState(() => _localProgress[a.id] = val),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("${_localProgress[a.id]!.round()}%"),
                  ),
                  const Divider(),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Skip"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Style.orange),
          onPressed: () => widget.onSave(_localProgress),
          child: const Text(
            "Save & Finish",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
