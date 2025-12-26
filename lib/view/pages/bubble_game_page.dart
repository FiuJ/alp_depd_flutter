part of 'pages.dart';

class BubbleGamePage extends StatelessWidget {
  const BubbleGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BubbleGameViewmodel>();

    return Scaffold(
      body: Stack(
        children: [
          const _GameBackground(),

          Column(
            children: [
              // GAME AREA
              Expanded(
                flex: 7,
                child: _Arena(
                  columns: vm.columns,
                  bubbles: vm.bubbles,
                  isAiming: vm.isAiming,
                  aimPosition: vm.aimPosition,
                ),
              ),

              // SHOOTER
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onPanStart: (_) => vm.startAiming(),
                  onPanUpdate: (d) => vm.updateAim(d.localPosition),
                  onPanEnd: (_) => vm.shoot(),
                  child: _Shooter(vm.currentBallColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ================= UI ================= */

class _GameBackground extends StatelessWidget {
  const _GameBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1B1E3C),
            Color(0xFF2C2F5C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _Arena extends StatelessWidget {
  final int columns;
  final List bubbles;
  final bool isAiming;
  final Offset aimPosition;

  const _Arena({
    required this.columns,
    required this.bubbles,
    required this.isAiming,
    required this.aimPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = constraints.maxWidth / columns;

          return Stack(
            children: [
              Wrap(
                children: bubbles.map<Widget>((bubble) {
                  return SizedBox(
                    width: cellSize,
                    height: cellSize,
                    child: _MarbleBubble(bubble.color),
                  );
                }).toList(),
              ),

              if (isAiming)
                CustomPaint(
                  size: Size.infinite,
                  painter: _AimPainter(aimPosition),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Shooter extends StatelessWidget {
  final Color color;

  const _Shooter(this.color);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _MarbleBubble(color),
    );
  }
}

class _MarbleBubble extends StatelessWidget {
  final Color color;

  const _MarbleBubble(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.4),
          colors: [
            Colors.white.withOpacity(0.85),
            color,
            color.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
    );
  }
}

/* ================= AIM LINE ================= */

class _AimPainter extends CustomPainter {
  final Offset aim;

  _AimPainter(this.aim);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2;

    final start = Offset(size.width / 2, size.height);
    canvas.drawLine(start, aim, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}