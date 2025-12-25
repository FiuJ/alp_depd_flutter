// import 'package:alp_depd_flutter/constants/colors.dart';
// import 'package:alp_depd_flutter/shared/style.dart';
// import 'package:alp_depd_flutter/viewmodel/stress_viewmodel.dart';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:alp_depd_flutter/view/widgets/custom_white_slider_thumb.dart';
part of 'pages.dart';

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

class StressFormDialog extends StatefulWidget {
  final int? assignmentId;
  const StressFormDialog({super.key, this.assignmentId});

  @override
  State<StressFormDialog> createState() => _StressFormDialogState();
}

class _StressFormDialogState extends State<StressFormDialog> {
  List<double> _values = List.filled(7, 3.0);
  final List<String> _questions = [
    "Seberapa stres perasaan Anda?",
    "Beban mental pengerjaan tugas?",
    "Kelelahan fisik yang dirasakan?",
    "Merasa dikejar waktu tadi?",
    "Kepuasan Anda terhadap hasil?",
    "Usaha keras untuk tetap fokus?",
    "Rasa frustrasi yang muncul?"
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<StressViewModel>(context);

    return Dialog(
      backgroundColor: Style.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Evaluasi Sesi", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Style.textColor)),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(7, (i) => _buildQuestionCard(i)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Nanti", style: TextStyle(color: Colors.grey)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Style.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: vm.isLoading ? null : () async {
                      List<int> scores = _values.map((e) => e.round()).toList();
                      if (await vm.saveStressRecord(scores, widget.assignmentId)) {
                        Navigator.pop(context);
                      }
                    },
                    child: vm.isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${i + 1}. ${_questions[i]}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Style.textColor)),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 10,
              activeTrackColor: Style.orange,
              inactiveTrackColor: Colors.grey[200],
              thumbShape: const CustomWhiteSliderThumb(thumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
            ),
            child: Slider(
              value: _values[i], min: 1, max: 5, divisions: 4,
              onChanged: (v) => setState(() => _values[i] = v),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Rendah", style: TextStyle(fontSize: 10, color: Colors.grey[400])),
              Text("Tinggi", style: TextStyle(fontSize: 10, color: Colors.grey[400])),
            ],
          )
        ],
      ),
    );
  }
}