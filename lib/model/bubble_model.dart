part of 'model.dart';

enum BubbleColor { red, blue, green, yellow }

class Bubble {
  BubbleColor color;
  Offset position;
  bool isMoving;

  Bubble({
    required this.color,
    required this.position,
    this.isMoving = false,
  });
}
