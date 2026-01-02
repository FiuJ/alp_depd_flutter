part of 'pages.dart';

class BubbleGamePage extends StatelessWidget {
  const BubbleGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BubbleGameViewModel(),
      child: const Scaffold(
        backgroundColor: Color(0xFF1B1E3C), // Background gelap
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
        // 1. Hitung ukuran bola agar pas dengan lebar layar
        final double bubbleSize = constraints.maxWidth / BubbleGameViewModel.cols;
        
        // 2. Tentukan tinggi area permainan (Grid + Area terbang bola)
        // Kita ambil sebagian besar layar, sisakan sedikit di bawah untuk panel info jika perlu
        final double gameAreaHeight = constraints.maxHeight;

        return GestureDetector(
          // Kirim input sentuhan ke ViewModel
          onPanUpdate: (details) => vm.updateAim(
            details.localPosition, 
            Size(constraints.maxWidth, gameAreaHeight)
          ),
          onPanEnd: (_) => vm.shoot(bubbleSize, gameAreaHeight),
          
          child: Container(
            width: constraints.maxWidth,
            height: gameAreaHeight,
            color: Colors.transparent, // Transparan agar background Scaffold terlihat
            child: Stack(
              children: [
                // --- LAYER 1: GRID BOLA (Paling Bawah) ---
                for (int r = 0; r < BubbleGameViewModel.rows; r++)
                  for (int c = 0; c < BubbleGameViewModel.cols; c++)
                    if (vm.grid[r][c] != null)
                      Positioned(
                        top: r * bubbleSize,
                        left: c * bubbleSize,
                        child: _BubbleBall(color: vm.grid[r][c]!, size: bubbleSize),
                      ),

                // --- LAYER 2: GARIS PEMBATAS (DEAD LINE) ---
                Positioned(
                  top: BubbleGameViewModel.deadLineRow * bubbleSize,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.6), 
                          blurRadius: 8, 
                          spreadRadius: 2
                        )
                      ],
                    ),
                  ),
                ),
                
                // Label Peringatan di Garis
                Positioned(
                  top: (BubbleGameViewModel.deadLineRow * bubbleSize) - 14,
                  right: 8,
                  child: const Text(
                    "DANGER ZONE", 
                    style: TextStyle(
                      color: Colors.redAccent, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2
                    )
                  ),
                ),

                // --- LAYER 3: GARIS BIDIK (Aim Line) ---
                if (!vm.isShooting && !vm.isGameOver)
                  CustomPaint(
                    painter: _AimPainter(
                      angle: vm.aimAngle,
                      start: Offset(constraints.maxWidth / 2, gameAreaHeight - bubbleSize),
                    ),
                    size: Size(constraints.maxWidth, gameAreaHeight),
                  ),

                // --- LAYER 4: BOLA PENEMBAK (SHOOTER) - DIAM ---
                // Bola ini hanya terlihat jika sedang TIDAK menembak
                if (!vm.isShooting)
                  Positioned(
                    left: (constraints.maxWidth / 2) - (bubbleSize / 2),
                    top: gameAreaHeight - bubbleSize, // Posisi di bawah
                    child: _BubbleBall(color: vm.currentBall, size: bubbleSize),
                  ),

                // --- LAYER 5: PROYEKTIL (BOLA TERBANG) ---
                // Ini dirender TERAKHIR agar terbang di ATAS garis merah
                if (vm.isShooting)
                  Positioned(
                    left: vm.projectilePos.dx,
                    top: vm.projectilePos.dy,
                    child: _BubbleBall(color: vm.currentBall, size: bubbleSize),
                  ),

                // --- LAYER 6: OVERLAY GAME OVER ---
                if (vm.isGameOver)
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.dangerous, color: Colors.red, size: 80),
                          const SizedBox(height: 10),
                          const Text(
                            "GAME OVER",
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 36, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const Text(
                            "Bola melewati batas!",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            ),
                            onPressed: vm.resetGame,
                            child: const Text("COBA LAGI", style: TextStyle(fontSize: 18, color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- WIDGET PENDUKUNG ---

class _BubbleBall extends StatelessWidget {
  final Color color;
  final double size;

  const _BubbleBall({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    // Sedikit padding agar bola tidak terlihat saling menempel kotak
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.05), 
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.4, -0.4), // Efek cahaya dari kiri atas
            colors: [
              Colors.white.withOpacity(0.9), // Kilau
              color,
              Color.lerp(color, Colors.black, 0.4)!, // Bayangan
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(2, 2),
            )
          ],
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
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Menggambar garis putus-putus
    double distance = 0;
    // Pusat bola (offset sedikit agar garis mulai dari tengah bola)
    Offset centerStart = start + Offset(size.width / BubbleGameViewModel.cols / 2, size.width / BubbleGameViewModel.cols / 2);

    while (distance < 500) { // Panjang garis bidik
      double dx = cos(angle) * distance;
      double dy = sin(angle) * distance;
      
      Offset point = centerStart + Offset(dx, dy);
      
      // Berhenti menggambar jika keluar layar (opsional)
      if (point.dy < 0 || point.dx < 0 || point.dx > size.width) break;

      canvas.drawCircle(point, 2, paint..style = PaintingStyle.fill);
      distance += 20; // Jarak antar titik
    }
  }

  @override
  bool shouldRepaint(covariant _AimPainter oldDelegate) => oldDelegate.angle != angle;
}