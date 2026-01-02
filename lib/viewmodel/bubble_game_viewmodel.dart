import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class BubbleGameViewModel extends ChangeNotifier {
  static const int rows = 15; 
  static const int cols = 8;
  static const int deadLineRow = 10; 

  List<List<Color?>> grid = [];
  
  // STATUS GAME
  bool isShooting = false;
  bool isGameOver = false;
  bool isVictory = false; // Status Menang
  int score = 0; // Skor Pemain

  Color currentBall = Colors.red;
  Offset projectilePos = Offset.zero;
  Offset projectileVel = Offset.zero;
  double aimAngle = -pi / 2;

  Timer? _timer;

  BubbleGameViewModel() {
    resetGame();
  }

  void _initGrid() {
    // Isi 5 baris pertama saja agar pemain bisa menghabiskannya
    grid = List.generate(rows, (r) {
      return List.generate(cols, (c) => r < 5 ? _randomColor() : null);
    });
  }

  Color _randomColor() {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
    return colors[Random().nextInt(colors.length)];
  }

  void resetGame() {
    _initGrid();
    currentBall = _randomColor();
    isShooting = false;
    isGameOver = false;
    isVictory = false; // Reset status menang
    score = 0; // Reset skor
    notifyListeners();
  }

  void updateAim(Offset localPos, Size gameAreaSize) {
    if (isShooting || isGameOver || isVictory) return; // Cek isVictory juga
    
    final shooterPos = Offset(gameAreaSize.width / 2, gameAreaSize.height);
    double dx = localPos.dx - shooterPos.dx;
    double dy = localPos.dy - shooterPos.dy;
    
    aimAngle = atan2(dy, dx).clamp(-pi + 0.2, -0.2);
    notifyListeners();
  }

  void shoot(double bubbleSize, double gameHeight) {
    if (isShooting || isGameOver || isVictory) return; // Cek isVictory

    isShooting = true;
    double startX = (cols * bubbleSize) / 2 - (bubbleSize / 2);
    double startY = gameHeight - bubbleSize; 

    projectilePos = Offset(startX, startY);
    double speed = 25.0; 
    projectileVel = Offset(cos(aimAngle) * speed, sin(aimAngle) * speed);

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _updateProjectile(bubbleSize);
    });
  }

  void _updateProjectile(double bubbleSize) {
    projectilePos += projectileVel;

    // Pantulan Dinding
    if (projectilePos.dx <= 0 || projectilePos.dx >= (cols * bubbleSize) - bubbleSize) {
      projectileVel = Offset(-projectileVel.dx, projectileVel.dy);
      projectilePos = Offset(projectilePos.dx.clamp(0, (cols * bubbleSize) - bubbleSize), projectilePos.dy);
    }

    // Cek Berhenti (Atap atau Tabrakan Bola)
    if (projectilePos.dy <= 0 || _checkCollision(bubbleSize)) {
      _timer?.cancel();
      _snapToGrid(bubbleSize);
    }
    notifyListeners();
  }

  bool _checkCollision(double bubbleSize) {
    Offset pCenter = projectilePos + Offset(bubbleSize/2, bubbleSize/2);

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] != null) {
          Offset gCenter = Offset(c * bubbleSize + bubbleSize/2, r * bubbleSize + bubbleSize/2);
          if ((pCenter - gCenter).distance < bubbleSize * 0.85) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _snapToGrid(double bubbleSize) {
    int c = (projectilePos.dx / bubbleSize).round().clamp(0, cols - 1);
    int r = (projectilePos.dy / bubbleSize).round().clamp(0, rows - 1);

    while (r < rows && grid[r][c] != null) {
      r++;
    }

    // CEK GAME OVER
    if (r >= deadLineRow) {
      isGameOver = true;
      if (r < rows) grid[r][c] = currentBall; 
    } else {
      // Pasang bola
      if (r < rows) {
        grid[r][c] = currentBall;
        _checkMatches(r, c);
        
        // SETELAH MATCH SELESAI, CEK APAKAH MENANG?
        _checkVictory();
      }
    }

    isShooting = false;
    currentBall = _randomColor();
    notifyListeners();
  }

  void _checkMatches(int r, int c) {
    List<Point<int>> matches = [];
    _floodFill(r, c, grid[r][c]!, matches);
    
    if (matches.length >= 3) {
      // TAMBAH SKOR
      score += matches.length * 10;
      
      for (var p in matches) {
        grid[p.y][p.x] = null;
      }
    }
  }

  // Fungsi Baru: Cek Kemenangan
  void _checkVictory() {
    bool hasBall = false;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] != null) {
          hasBall = true;
          break;
        }
      }
    }
    
    // Jika tidak ada bola tersisa, Menang!
    if (!hasBall) {
      isVictory = true;
      score += 1000; // Bonus skor jika menang
    }
  }

  void _floodFill(int r, int c, Color color, List<Point<int>> matches) {
    if (r < 0 || r >= rows || c < 0 || c >= cols) return;
    if (grid[r][c] != color || matches.contains(Point(c, r))) return;

    matches.add(Point(c, r));

    _floodFill(r + 1, c, color, matches);
    _floodFill(r - 1, c, color, matches);
    _floodFill(r, c + 1, color, matches);
    _floodFill(r, c - 1, color, matches);
  }
}