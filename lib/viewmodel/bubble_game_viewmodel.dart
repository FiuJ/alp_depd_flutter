import 'dart:math';
import 'package:flutter/material.dart';
import '../model/model.dart';

class BubbleGameViewmodel extends ChangeNotifier {
  final int columns = 8;
  final int rows = 6;

  final Random _random = Random();

  List<Bubble> bubbles = [];
  Color currentBallColor = bubbleColors.first;

  Offset aimPosition = Offset.zero;
  bool isAiming = false;

  BubbleGameViewmodel() {
    _generateGrid();
    _generateNextBall();
  }

  void _generateGrid() {
    bubbles.clear();
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        bubbles.add(
          Bubble(
            row: r,
            col: c,
            color: bubbleColors[_random.nextInt(bubbleColors.length)],
          ),
        );
      }
    }
    notifyListeners();
  }

  void _generateNextBall() {
    currentBallColor =
        bubbleColors[_random.nextInt(bubbleColors.length)];
    notifyListeners();
  }

  void startAiming() {
    isAiming = true;
    notifyListeners();
  }

  void updateAim(Offset position) {
    aimPosition = position;
    notifyListeners();
  }

  void shoot() {
    isAiming = false;

    // ⚠️ Placeholder physics hook
    _generateNextBall();
  }
}
