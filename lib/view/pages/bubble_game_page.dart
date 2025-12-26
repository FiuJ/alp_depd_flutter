part of 'pages.dart';

class BubbleGamePage extends StatefulWidget {
  const BubbleGamePage({super.key});

  @override
  State<BubbleGamePage> createState() => _BubbleGamePageState();
}

class _BubbleGamePageState extends State<BubbleGamePage> {
  late BubbleGameViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = BubbleGameViewModel();
  }

  Color _mapColor(BubbleColor color) {
    switch (color) {
      case BubbleColor.red:
        return Colors.red;
      case BubbleColor.blue:
        return Colors.blue;
      case BubbleColor.green:
        return Colors.green;
      case BubbleColor.yellow:
        return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanUpdate: (details) {
          vm.updateAim(details.localPosition - vm.shooterPosition);
          setState(() {});
        },
        onPanEnd: (_) {
          vm.shootBubble(() => setState(() {}));
        },
        child: Stack(
          children: [
            ..._buildGrid(),
            _buildAimLine(),
            _buildCurrentBubble(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGrid() {
    final widgets = <Widget>[];

    for (var row in vm.grid) {
      for (var bubble in row) {
        if (bubble == null) continue;
        widgets.add(
          Positioned(
            left: bubble.position.dx,
            top: bubble.position.dy,
            child: _bubbleWidget(bubble.color),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildCurrentBubble() {
    return Positioned(
      left: vm.currentBubble.position.dx,
      top: vm.currentBubble.position.dy,
      child: _bubbleWidget(vm.currentBubble.color),
    );
  }

  Widget _bubbleWidget(BubbleColor color) {
    return Container(
      width: vm.bubbleSize,
      height: vm.bubbleSize,
      decoration: BoxDecoration(
        color: _mapColor(color),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildAimLine() {
    return CustomPaint(
      painter: _AimPainter(
        start: vm.shooterPosition,
        direction: vm.aimDirection,
      ),
      size: Size.infinite,
    );
  }
}

class _AimPainter extends CustomPainter {
  final Offset start;
  final Offset direction;

  _AimPainter({required this.start, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    if (direction == Offset.zero) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    canvas.drawLine(
      start,
      start + direction * 3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
