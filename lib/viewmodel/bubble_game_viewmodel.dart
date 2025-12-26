import 'dart:async';
import 'dart:math';
import 'dart:ui';

import '../model/model.dart';

class BubbleGameViewModel {
  final int rows = 8;
  final int cols = 8;
  final double bubbleSize = 36;

  late List<List<Bubble?>> grid;
  late Bubble currentBubble;

  Offset shooterPosition = const Offset(180, 520);
  Offset aimDirection = Offset.zero;

  final Random _random = Random();

  BubbleGameViewModel() {
    resetGame();
  }

  void resetGame() {
    grid = List.generate(
      rows,
      (_) => List.generate(cols, (_) => null),
    );

    _generateInitialGrid();
    _spawnNewBubble();
  }

  void _generateInitialGrid() {
    for (int r = 0; r < 5; r++) {
      for (int c = 0; c < cols; c++) {
        grid[r][c] = Bubble(
          color: _randomColor(),
          position: _gridToPosition(r, c),
        );
      }
    }
  }

  void _spawnNewBubble() {
    currentBubble = Bubble(
      color: _randomColor(),
      position: shooterPosition,
      isMoving: false,
    );
  }

  BubbleColor _randomColor() {
    return BubbleColor.values[_random.nextInt(4)];
  }

  Offset _gridToPosition(int row, int col) {
    return Offset(
      col * bubbleSize + 20,
      row * bubbleSize + 20,
    );
  }

  void updateAim(Offset direction) {
    aimDirection = direction;
  }

  void shootBubble(VoidCallback onUpdate) {
    if (currentBubble.isMoving) return;

    currentBubble.isMoving = true;
    Offset velocity =
        aimDirection / aimDirection.distance * 8;

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      currentBubble.position += velocity;

      // pantul kiri-kanan
      if (currentBubble.position.dx <= 0 ||
          currentBubble.position.dx >= 360) {
        velocity = Offset(-velocity.dx, velocity.dy);
      }

      if (_checkCollision()) {
        timer.cancel();
        _attachBubble();
        onUpdate();
        return;
      }

      onUpdate();
    });
  }

  bool _checkCollision() {
    for (var row in grid) {
      for (var bubble in row) {
        if (bubble == null) continue;
        if ((bubble.position - currentBubble.position).distance <
            bubbleSize) {
          return true;
        }
      }
    }

    // nempel ke atas
    if (currentBubble.position.dy <= 20) return true;

    return false;
  }

  void _attachBubble() {
    int row =
        ((currentBubble.position.dy - 20) / bubbleSize).round();
    int col =
        ((currentBubble.position.dx - 20) / bubbleSize).round();

    row = row.clamp(0, rows - 1);
    col = col.clamp(0, cols - 1);

    grid[row][col] = Bubble(
      color: currentBubble.color,
      position: _gridToPosition(row, col),
    );

    _checkMatch(row, col);
    _spawnNewBubble();
  }

  void _checkMatch(int row, int col) {
    final matches = <Bubble>[];
    final visited = <String>{};

    void dfs(int r, int c) {
      if (r < 0 || c < 0 || r >= rows || c >= cols) return;
      final key = '$r-$c';
      if (visited.contains(key)) return;

      final bubble = grid[r][c];
      if (bubble == null ||
          bubble.color != grid[row][col]!.color) return;

      visited.add(key);
      matches.add(bubble);

      dfs(r + 1, c);
      dfs(r - 1, c);
      dfs(r, c + 1);
      dfs(r, c - 1);
    }

    dfs(row, col);

    if (matches.length >= 3) {
      for (var b in matches) {
        for (int r = 0; r < rows; r++) {
          for (int c = 0; c < cols; c++) {
            if (grid[r][c] == b) {
              grid[r][c] = null;
            }
          }
        }
      }
    }
  }
}
