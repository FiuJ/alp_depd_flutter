part of 'pages.dart';

class BubbleGamePage extends StatelessWidget {
  const BubbleGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BubbleGameViewModel(),
      child: const Scaffold(
        backgroundColor: ui.Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: _BubbleGameLayout(),
        ),
      ),
    );
  }
}

class _BubbleGameLayout extends StatelessWidget {
  const _BubbleGameLayout();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BubbleGameViewModel>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double bubbleSize = constraints.maxWidth / BubbleGameViewModel.cols;
        final double gameAreaHeight = constraints.maxHeight;

        return GestureDetector(
          onPanUpdate: (details) => vm.updateAim(
            details.localPosition, 
            Size(constraints.maxWidth, gameAreaHeight)
          ),
          onPanEnd: (_) => vm.shoot(bubbleSize, gameAreaHeight),
          
          child: Container(
            width: constraints.maxWidth,
            height: gameAreaHeight,
            color: Colors.transparent,
            child: Stack(
              children: [
                // 1. GRID BOLA
                for (int r = 0; r < BubbleGameViewModel.rows; r++)
                  for (int c = 0; c < BubbleGameViewModel.cols; c++)
                    if (vm.grid[r][c] != null)
                      Positioned(
                        top: r * bubbleSize,
                        left: c * bubbleSize,
                        child: _BubbleBall(color: vm.grid[r][c]!, size: bubbleSize),
                      ),

                // 2. GARIS PEMBATAS
                Positioned(
                  top: BubbleGameViewModel.deadLineRow * bubbleSize,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      boxShadow: [
                        BoxShadow(color: Colors.red.withOpacity(0.6), blurRadius: 8, spreadRadius: 2)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: (BubbleGameViewModel.deadLineRow * bubbleSize) - 14,
                  right: 8,
                  child: const Text("DANGER ZONE", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ),

                // 3. TAMPILAN SKOR (FITUR BARU)
                Positioned(
                  top: 10,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24)
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: Colors.amber, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          "SCORE: ${vm.score}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 4. GARIS BIDIK
                if (!vm.isShooting && !vm.isGameOver && !vm.isVictory)
                  CustomPaint(
                    painter: _AimPainter(
                      angle: vm.aimAngle,
                      start: Offset(constraints.maxWidth / 2, gameAreaHeight - bubbleSize),
                    ),
                    size: Size(constraints.maxWidth, gameAreaHeight),
                  ),

                // 5. BOLA SHOOTER (DIAM)
                if (!vm.isShooting && !vm.isVictory) // Sembunyikan jika menang
                  Positioned(
                    left: (constraints.maxWidth / 2) - (bubbleSize / 2),
                    top: gameAreaHeight - bubbleSize,
                    child: _BubbleBall(color: vm.currentBall, size: bubbleSize),
                  ),

                // 6. PROYEKTIL (TERBANG)
                if (vm.isShooting)
                  Positioned(
                    left: vm.projectilePos.dx,
                    top: vm.projectilePos.dy,
                    child: _BubbleBall(color: vm.currentBall, size: bubbleSize),
                  ),

                // 7. OVERLAY: GAME OVER (KALAH)
                if (vm.isGameOver)
                  _ResultOverlay(
                    title: "GAME OVER",
                    message: "Bola melewati batas!",
                    color: Colors.red,
                    icon: Icons.dangerous,
                    onRetry: vm.resetGame,
                  ),

                // 8. OVERLAY: VICTORY (MENANG - FITUR BARU)
                if (vm.isVictory)
                  _ResultOverlay(
                    title: "VICTORY!",
                    message: "Semua bola bersih! Skor: ${vm.score}",
                    color: Colors.greenAccent,
                    icon: Icons.emoji_events,
                    onRetry: vm.resetGame,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget Overlay untuk Menang/Kalah (Reusable)
class _ResultOverlay extends StatelessWidget {
  final String title;
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onRetry;

  const _ResultOverlay({
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 80),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(color: color, fontSize: 36, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(message, style: const TextStyle(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.black, // Warna teks tombol
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: onRetry,
              child: const Text("MAIN LAGI", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

class _BubbleBall extends StatelessWidget {
  final Color color;
  final double size;
  const _BubbleBall({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.05), 
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.4, -0.4),
            colors: [Colors.white.withOpacity(0.9), color, Color.lerp(color, Colors.black, 0.4)!],
            stops: const [0.0, 0.3, 1.0],
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(2, 2))],
        ),
      ),
    );
  }
}

class _AimPainter extends CustomPainter {
  final double angle;
  final Offset start;
  _AimPainter({required this.angle, required this.start});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const ui.Color.fromARGB(251, 255, 174, 0)..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    double distance = 0;
    Offset centerStart = start + Offset(size.width / BubbleGameViewModel.cols / 2, size.width / BubbleGameViewModel.cols / 2);
    while (distance < 500) {
      double dx = cos(angle) * distance;
      double dy = sin(angle) * distance;
      Offset point = centerStart + Offset(dx, dy);
      if (point.dy < 0 || point.dx < 0 || point.dx > size.width) break;
      canvas.drawCircle(point, 2, paint..style = PaintingStyle.fill);
      distance += 20;
    }
  }
  @override
  bool shouldRepaint(covariant _AimPainter oldDelegate) => oldDelegate.angle != angle;
}