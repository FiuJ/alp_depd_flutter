part of 'model.dart';

class Bubble {
  final Color color;

  Bubble({required this.color});

  static final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];

  static Bubble random() {
    return Bubble(color: colors[Random().nextInt(colors.length)]);
  }

  static Color randomColor() {
    return colors[Random().nextInt(colors.length)];
  }
}

extension on Random {
  nextInt(int length) {}
}
