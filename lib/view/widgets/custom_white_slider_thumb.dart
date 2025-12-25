import 'dart:ui' as ui;
import 'package:flutter/material.dart';

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
    required ui.Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    final canvas = context.canvas;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}
