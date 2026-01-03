part of 'pages.dart';

// --- Custom Slider Thumb ---
// class CustomWhiteSliderThumb extends SliderComponentShape {
//   final double thumbRadius;
//   const CustomWhiteSliderThumb({this.thumbRadius = 5.0});

//   @override
//   ui.Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return ui.Size.fromRadius(thumbRadius);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required ui.Size sizeWithOverflow,
//   }) {
//     final Canvas canvas = context.canvas;
//     final Paint paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final Paint borderPaint = Paint()
//       ..color = Colors.grey[400]!
//       ..strokeWidth = 0.8
//       ..style = PaintingStyle.stroke;

//     canvas.drawCircle(center, thumbRadius, paint);
//     canvas.drawCircle(center, thumbRadius, borderPaint);
//   }
// }

// --- Settings Page ---
class Timersettingspage extends StatefulWidget {
  const Timersettingspage({super.key});

  @override
  State<Timersettingspage> createState() => _TimersettingspageState();
}

class _TimersettingspageState extends State<Timersettingspage> {
  double workDuration = 25.0;
  double breakDuration = 5.0;
  int cycles = 4;

  @override
  Widget build(BuildContext context) {
    // Assuming you use Provider for state management
    final timerVM = Provider.of<Timerviewmodel>(context);

    return Scaffold(
      backgroundColor: Style.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              SvgPicture.asset('assets/images/Yucca.svg', height: 287),
              const SizedBox(height: 16),

              // 1. Work Duration Slider
              _buildSettingCard(
                label: 'Work',
                value: workDuration,
                icon: Icons.timer,
                min: 1,
                max: 60,
                divisions: 59,
                onChanged: (val) => setState(() => workDuration = val),
              ),
              const SizedBox(height: 12),

              // 2. Break Duration Slider
              _buildSettingCard(
                label: 'Break',
                value: breakDuration,
                icon: Icons.coffee,
                min: 1,
                max: 30,
                divisions: 29,
                onChanged: (val) => setState(() => breakDuration = val),
              ),
              const SizedBox(height: 12),

              // 3. Cycles Slider
              _buildSettingCard(
                label: 'Cycles',
                value: cycles.toDouble(),
                icon: Icons.repeat,
                min: 1,
                max: 20,
                divisions: 19,
                onChanged: (val) => setState(() => cycles = val.toInt()),
              ),
              const SizedBox(height: 12),

              // 4. Assignment Selection Card (with "View All")
              _buildAssignmentSelectionCard(timerVM),

              const SizedBox(height: 20),

              // 5. Start Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Style.orange,
                    minimumSize: const Size.fromHeight(58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'TimerPage'),
                        builder: (context) => TimerPage(
                          workDuration: workDuration,
                          breakDuration: breakDuration,
                          cycles: cycles,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Start Session',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable Setting Slider Card ---
  Widget _buildSettingCard({
    required String label,
    required double value,
    required IconData icon,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Style.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6.0),
                child: Icon(icon, size: 30, color: const Color(0XFFFCFCFC)),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Style.textColor,
                ),
              ),
              const Spacer(),
              Text(
                '${value.toStringAsFixed(0)} ${label == "Cycles" ? "" : "min"}',
                style: TextStyle(fontSize: 20, color: Style.textColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 12,
              activeTrackColor: Style.orange,
              inactiveTrackColor: Colors.grey[300],
              thumbShape: const CustomWhiteSliderThumb(thumbRadius: 5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 6),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // --- Assignment "Cart" Card ---
  Widget _buildAssignmentSelectionCard(Timerviewmodel timerVM) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Style.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6.0),
                child: const Icon(
                  Icons.assignment,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Assignments',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AssignmentListPage(),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Style.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (timerVM.selectedAssignments.isEmpty)
            const Text(
              "No tasks selected for this session.",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: timerVM.selectedAssignments
                  .map(
                    (a) => Chip(
                      label: Text(
                        a.title,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onDeleted: () => timerVM.toggleSelection(a),
                      deleteIcon: const Icon(Icons.cancel, size: 16),
                      deleteIconColor: Colors.redAccent,
                      backgroundColor: Style.orange.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
