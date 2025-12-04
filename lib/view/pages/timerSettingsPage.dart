part of 'pages.dart';

class CustomWhiteSliderThumb extends SliderComponentShape {
  final double thumbRadius;

  const CustomWhiteSliderThumb({this.thumbRadius = 5.0});

  @override
  ui.Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return ui.Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required ui.Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, paint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}

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
    return Scaffold(
      backgroundColor: Style.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            children: [
              SvgPicture.asset('assets/images/Yucca.svg', height: 287),
              // Image.asset('assets/images/yucca.svg'),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 32.0,
                  top: 16.0,
                ),
                child: Column(
                  children: [
                    // Work Duration Section
                    Container(
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Style.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(6.0),
                                child: const Icon(
                                  Icons.timer,
                                  size: 30,
                                  color: Color(0XFFFCFCFC),
                                ),
                              ),

                              const SizedBox(width: 10),
                              Text(
                                'Work',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Style.textColor,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${workDuration.toStringAsFixed(0)} min',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Style.textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 12,
                              activeTrackColor: Style.orange,
                              inactiveTrackColor: Colors.grey[300],
                              thumbShape: const CustomWhiteSliderThumb(
                                thumbRadius: 5,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 6,
                              ),
                            ),
                            child: Slider(
                              value: workDuration,
                              min: 1,
                              max: 60,
                              divisions: 59,
                              label: '${workDuration.toStringAsFixed(0)} min',
                              onChanged: (newValue) {
                                setState(() {
                                  workDuration = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Break Duration Section
                    Container(
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Style.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(6.0),
                                child: const Icon(
                                  Icons.coffee,
                                  size: 30,
                                  color: Color(0XFFFCFCFC),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Break',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Style.textColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${breakDuration.toStringAsFixed(0)} min',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Style.textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 12,
                              activeTrackColor: Style.orange,
                              inactiveTrackColor: Colors.grey[300],
                              thumbShape: const CustomWhiteSliderThumb(
                                thumbRadius: 5,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 6,
                              ),
                            ),
                            child: Slider(
                              value: breakDuration,
                              min: 1,
                              max: 30,
                              divisions: 29,
                              label: '${breakDuration.toStringAsFixed(0)} min',
                              onChanged: (newValue) {
                                setState(() {
                                  breakDuration = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cycles Section
                    Container(
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Style.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(6.0),
                                child: const Icon(
                                  Icons.repeat,
                                  size: 30,
                                  color: Color(0XFFFCFCFC),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Cycles',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Style.textColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '$cycles',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Style.textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 12,
                              activeTrackColor: Style.orange,
                              inactiveTrackColor: Colors.grey[300],
                              thumbShape: const CustomWhiteSliderThumb(
                                thumbRadius: 5,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 6,
                              ),
                            ),
                            child: Slider(
                              value: cycles.toDouble(),
                              min: 1,
                              max: 20,
                              divisions: 19,
                              label: '$cycles',
                              onChanged: (newValue) {
                                setState(() {
                                  cycles = newValue.toInt();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Style.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          minimumSize: const Size.fromHeight(58),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
