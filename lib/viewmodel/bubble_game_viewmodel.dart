import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class BubbleGameViewModel extends ChangeNotifier {
  static const int rows = 15; 
  static const int cols = 8;
  static const int deadLineRow = 10; // Baris batas Game Over

  List<List<Color?>> grid = [];
  bool isShooting = false;
  bool isGameOver = false;

  Color currentBall = Colors.red;
  Offset projectilePos = Offset.zero;
  Offset projectileVel = Offset.zero;
  double aimAngle = -pi / 2;

  Timer? _timer;

  BubbleGameViewModel() {
    resetGame();
  }

  void _initGrid() {
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
    notifyListeners();
  }

  void updateAim(Offset localPos, Size gameAreaSize) {
    if (isShooting || isGameOver) return;
    
    // Pusat shooter di tengah bawah area permainan
    final shooterPos = Offset(gameAreaSize.width / 2, gameAreaSize.height);
    
    double dx = localPos.dx - shooterPos.dx;
    double dy = localPos.dy - shooterPos.dy;
    
    aimAngle = atan2(dy, dx).clamp(-pi + 0.2, -0.2);
    notifyListeners();
  }

  void shoot(double bubbleSize, double gameHeight) {
    if (isShooting || isGameOver) return;

    isShooting = true;
    
    // Posisi awal bola
    double startX = (cols * bubbleSize) / 2 - (bubbleSize / 2);
    // Sedikit di atas bawah layar agar tidak langsung trigger collision dgn dinding bawah
    double startY = gameHeight - bubbleSize; 

    projectilePos = Offset(startX, startY);
    
    double speed = 25.0; 
    projectileVel = Offset(cos(aimAngle) * speed, sin(aimAngle) * speed);

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _updateProjectile(bubbleSize);
    });
  }

  // --- PERBAIKAN UTAMA ADA DI SINI ---
  void _updateProjectile(double bubbleSize) {
    projectilePos += projectileVel;

    // 1. Pantulan Dinding Kiri/Kanan
    if (projectilePos.dx <= 0 || projectilePos.dx >= (cols * bubbleSize) - bubbleSize) {
      projectileVel = Offset(-projectileVel.dx, projectileVel.dy);
      projectilePos = Offset(projectilePos.dx.clamp(0, (cols * bubbleSize) - bubbleSize), projectilePos.dy);
    }

    // 2. Cek Berhenti: HANYA jika kena atap ATAU menabrak bola lain.
    // JANGAN CEK GARIS BATAS DI SINI! Biarkan bola lewat.
    if (projectilePos.dy <= 0 || _checkCollision(bubbleSize)) {
      _timer?.cancel();
      _snapToGrid(bubbleSize);
    }
    notifyListeners();
  }

  bool _checkCollision(double bubbleSize) {
    // Titik tengah bola proyektil
    Offset pCenter = projectilePos + Offset(bubbleSize/2, bubbleSize/2);

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        // Hanya cek tabrakan dengan bola yang SUDAH ADA di grid
        if (grid[r][c] != null) {
          Offset gCenter = Offset(c * bubbleSize + bubbleSize/2, r * bubbleSize + bubbleSize/2);
          
          // Jika jarak cukup dekat, dianggap menabrak
          if ((pCenter - gCenter).distance < bubbleSize * 0.85) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _snapToGrid(double bubbleSize) {
    // Hitung posisi grid tempat bola berhenti
    int c = (projectilePos.dx / bubbleSize).round().clamp(0, cols - 1);
    int r = (projectilePos.dy / bubbleSize).round().clamp(0, rows - 1);

    // Jika slot penuh, cari slot kosong di bawahnya (agar tidak menumpuk)
    while (r < rows && grid[r][c] != null) {
      r++;
    }

    // --- CEK GAME OVER DILAKUKAN DI SINI ---
    // Game Over hanya terjadi jika BOLA BERHENTI (nempel) di bawah garis merah.
    if (r >= deadLineRow) {
      isGameOver = true;
      if (r < rows) grid[r][c] = currentBall; // Tampilkan bola penyebab kalah
    } else {
      // Jika aman, pasang bola dan cek match-3
      if (r < rows) {
        grid[r][c] = currentBall;
        _checkMatches(r, c);
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
      for (var p in matches) {
        grid[p.y][p.x] = null;
      }
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