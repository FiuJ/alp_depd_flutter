part of 'model.dart';

class Bubble {
  final int row;
  final int col;
  final Color color;

  Bubble({
    required this.row,
    required this.col,
    required this.color,
  });
}

const List<Color> bubbleColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
];
