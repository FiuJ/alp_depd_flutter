part of 'pages.dart';

class TimerPage extends StatefulWidget {
  final double workDuration;
  final double breakDuration;
  final int cycles;
  static const routeName = '/timer';

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 1. ACCESS GLOBAL PROVIDER: Do not use = Timerviewmodel() in initState
    _viewModel = Provider.of<Timerviewmodel>(context, listen: false);

    // 2. SET CALLBACKS: Ensure they are attached once
    _viewModel.setPhaseCompleteCallback(_showPhaseCompleteDialog);
    _viewModel.setAllCyclesCompleteCallback(_handleAllCyclesComplete);

    // 3. INITIALIZE: Setup data only if the timer is fresh
    if (!_viewModel.isRunning && _viewModel.currentCycle == 1) {
      _viewModel.initialize(
        widget.workDuration,
        widget.breakDuration,
        widget.cycles,
      );
    }

    _viewModel.setBreakFinishedCallback(() {
      if (!mounted) return;

      Navigator.of(
        context,
      ).popUntil((route) => route.settings.name == 'TimerPage');
    });
  }

  // void _handleAllCyclesComplete() async {
  //   if (mounted) {
  //     if (_viewModel.selectedAssignments.isNotEmpty) {
  //       await showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) => ProgressUpdateDialog(
  //           assignments: _viewModel.selectedAssignments,
  //           onSave: (progressUpdates) async {
  //             await _viewModel.finalizeSession(progressUpdates);
  //             if (mounted) {
  //               Navigator.pop(context); // Close Dialog
  //               Navigator.pop(context); // Return to Settings
  //             }
  //           },
  //         ),
  //       );
  //     } else {
  //       Navigator.pop(context);
  //     }
  //   }
  // }

  void _handleAllCyclesComplete() async {
    if (mounted) {
      if (_viewModel.selectedAssignments.isNotEmpty) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ProgressUpdateDialog(
            assignments: _viewModel.selectedAssignments,
            onSave: (progressUpdates) async {
              await _viewModel.finalizeSession(progressUpdates);

              if (mounted) {
                Navigator.pop(context); // Tutup Progress Dialog

                // --- INTEGRASI PROMPT STRES DISINI ---
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text(
                      "Sesi Selesai!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      "Ingin mencatat tingkat stresmu agar bisa dipantau di grafik kesehatan mental?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Nanti"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Style.orange,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // Ambil ID tugas pertama jika ada untuk relasi database
                          int? firstId =
                              _viewModel.selectedAssignments.isNotEmpty
                              ? int.tryParse(
                                  _viewModel.selectedAssignments.first.id,
                                )
                              : null;
                          showDialog(
                            context: context,
                            builder: (c) =>
                                StressFormDialog(assignmentId: firstId),
                          );
                        },
                        child: const Text(
                          "Mulai Cek",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );

                if (mounted) Navigator.pop(context); // Kembali ke Settings
              }
            },
          ),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _showPhaseCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _BreakDialog(
        viewModel: _viewModel,
        onContinue: () => _viewModel.moveToNextPhaseFromDialog(),
      ),
    );
  }

  @override
  void dispose() {
    // 4. CLEANUP: Reset timer but do NOT dispose a global provider
    _viewModel.resetTimer();
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
                      Text(
                        _viewModel.isWorkPhase ? 'Work' : 'Break',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Style.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cycle ${_viewModel.currentCycle} of ${_viewModel.cycles}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                                      heroTag: "timer_play_pause", // UNIQUE TAG
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
                                      heroTag: "timer_skip", // UNIQUE TAG
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
                SvgPicture.asset('assets/images/YuccaWork.svg', height: 300),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- FIXED BREAK DIALOG ---
class _BreakDialog extends StatelessWidget {
  final Timerviewmodel viewModel;
  final VoidCallback onContinue;

  const _BreakDialog({
    super.key,
    required this.viewModel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return AlertDialog(
          title: const Text('Work Phase Complete!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cycle ${viewModel.currentCycle} of ${viewModel.cycles}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              // Reactive countdown watching the ViewModel
              Text(
                viewModel.formattedTime,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                viewModel.isRunning
                    ? "Taking a break..."
                    : "Ready for your break?",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Style.orange),
              onPressed: () {
                Navigator.pop(context); // Close dialog

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Minigame()),
                );
              },
              child: const Text(
                "Do Break Activity",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                viewModel
                    .skipPhase(); // Skips break directly to next work phase
              },
              child: const Text('Skip Break'),
            ),
          ],
        );
      },
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
    // 5. TYPE FIX: Convert the model's 'int' to 'double' for the Slider
    _localProgress = {
      for (var a in widget.assignments) a.id: a.progress.toDouble(),
    };
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
                    onChanged: (val) =>
                        setState(() => _localProgress[a.id] = val),
                  ),
                  Text("${_localProgress[a.id]!.round()}%"),
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
