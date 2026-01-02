import 'dart:ui';
import 'package:flutter/material.dart';

class Point{
  int x;
  int y;
  Point(this.x, this.y);
}

enum TetrominoType { I, O, T, S, Z, J, L }

class TetrisConstants {
  static const int rowCount = 20;
  static const int colCount = 10;
  
  static const Map<TetrominoType, List<List<int>>> shapes = {
    TetrominoType.I: [[0,0], [0,1], [0,2], [0,3]],
    TetrominoType.O: [[0,0], [0,1], [1,0], [1,1]],
    TetrominoType.T: [[0,0], [0,1], [0,2], [1,1]],
    TetrominoType.S: [[0,1], [0,2], [1,0], [1,1]],
    TetrominoType.Z: [[0,0], [0,1], [1,1], [1,2]],
    TetrominoType.J: [[0,0], [0,1], [0,2], [1,2]],
    TetrominoType.L: [[0,0], [0,1], [0,2], [1,0]],
  };

  static const Map<TetrominoType, Color> colors = {
    TetrominoType.I: Color(0xFFD32F2F), 
    TetrominoType.O: Color(0xFFFBC02D), 
    TetrominoType.T: Color(0xFF5D4037),  
    TetrominoType.S: Color(0xFFE64A19), 
    TetrominoType.Z: Color(0xFF8D6E63), 
    TetrominoType.J: Color(0xFFF57C00), 
    TetrominoType.L: Color(0xFF795548), 
  };
}