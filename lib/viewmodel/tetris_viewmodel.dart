import 'dart:async';
import 'dart:math';
import 'package:alp_depd_flutter/model/model.dart';
import 'package:flutter/material.dart';

class TetrisViewModel extends ChangeNotifier {
  late List<List<Color?>> board;

  late List<Point> currentPiece;
  late Color currentPieceColor;
  late TetrominoType currentType;
  Point currentPosition = Point(0, 0);

  TetrominoType? nextType;
  Color? nextPieceColor;

  int score = 0;
  bool isGameOver = false;
  bool isPlaying = false;
  Timer? _gameTimer;

  TetrisViewModel() {
    _initBoard();
  }

  void _initBoard() {
    board = List.generate(
      TetrisConstants.rowCount,
      (_) => List.generate(TetrisConstants.colCount, (_) => null),
    );
  }

  void startGame() {
    _initBoard();
    score = 0;
    isGameOver = false;
    isPlaying = true;

    _generateNextPiece();

    _spawnPiece();

    _startGameLoop();
    notifyListeners();
  }

  void _startGameLoop() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (isPlaying && !isGameOver) {
        moveDown();
      }
    });
  }

  void _generateNextPiece() {
    Random rng = Random();
    nextType = TetrominoType.values[rng.nextInt(TetrominoType.values.length)];
    nextPieceColor = TetrisConstants.colors[nextType]!;
  }

  void _spawnPiece() {
    currentType = nextType!;
    currentPieceColor = nextPieceColor!;

    currentPiece = TetrisConstants.shapes[currentType]!
        .map((p) => Point(p[0], p[1]))
        .toList();

    currentPosition = Point(0, 4);

    _generateNextPiece();

    if (!_isValidPosition(currentPiece, currentPosition)) {
      isGameOver = true;
      isPlaying = false;
      _gameTimer?.cancel();
    }
    notifyListeners();
  }

  void moveDown() {
    if (isGameOver) return;
    Point nextPos = Point(currentPosition.x + 1, currentPosition.y);
    if (_isValidPosition(currentPiece, nextPos)) {
      currentPosition = nextPos;
    } else {
      _lockPiece();
      _clearLines();
      _spawnPiece();
    }
    notifyListeners();
  }

  void moveLeft() {
    if (isGameOver) return;
    Point nextPos = Point(currentPosition.x, currentPosition.y - 1);
    if (_isValidPosition(currentPiece, nextPos)) {
      currentPosition = nextPos;
      notifyListeners();
    }
  }

  void moveRight() {
    if (isGameOver) return;
    Point nextPos = Point(currentPosition.x, currentPosition.y + 1);
    if (_isValidPosition(currentPiece, nextPos)) {
      currentPosition = nextPos;
      notifyListeners();
    }
  }

  void rotate() {
    if (isGameOver) return;
    List<Point> rotatedPiece = currentPiece
        .map((p) => Point(p.y, 3 - p.x))
        .toList();
    if (_isValidPosition(rotatedPiece, currentPosition)) {
      currentPiece = rotatedPiece;
      notifyListeners();
    }
  }

  bool _isValidPosition(List<Point> piece, Point pos) {
    for (var p in piece) {
      int row = pos.x + p.x;
      int col = pos.y + p.y;
      if (col < 0 ||
          col >= TetrisConstants.colCount ||
          row >= TetrisConstants.rowCount)
        return false;
      if (row >= 0 && board[row][col] != null) return false;
    }
    return true;
  }

  void _lockPiece() {
    for (var p in currentPiece) {
      int row = currentPosition.x + p.x;
      int col = currentPosition.y + p.y;
      if (row >= 0 &&
          row < TetrisConstants.rowCount &&
          col >= 0 &&
          col < TetrisConstants.colCount) {
        board[row][col] = currentPieceColor;
      }
    }
  }

  void _clearLines() {
    for (int row = TetrisConstants.rowCount - 1; row >= 0; row--) {
      bool isFull = true;
      for (int col = 0; col < TetrisConstants.colCount; col++) {
        if (board[row][col] == null) {
          isFull = false;
          break;
        }
      }
      if (isFull) {
        for (int r = row; r > 0; r--) {
          board[r] = List.from(board[r - 1]);
        }
        board[0] = List.generate(TetrisConstants.colCount, (_) => null);
        score += 100;
        row++;
      }
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
