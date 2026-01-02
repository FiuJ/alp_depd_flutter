part of 'pages.dart';

class TetrisView extends StatelessWidget {
  const TetrisView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.brown[900]!;
    final Color gridBorderColor = Colors.brown[100]!;

    return ChangeNotifierProvider(
      create: (_) => TetrisViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            // 1. HEADER (Score & Next)
            Consumer<TetrisViewModel>(
              builder: (context, tetris, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("SCORE",
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          Text("${tetris.score}",
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("NEXT",
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.brown[200]!)),
                            child: tetris.isPlaying && tetris.nextType != null
                                ? Center(
                                    child: _buildNextPiece(tetris.nextType!,
                                        tetris.nextPieceColor!))
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            // 2. GRID
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio:
                      TetrisConstants.colCount / TetrisConstants.rowCount,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: gridBorderColor, width: 2),
                      color: Colors.white,
                    ),
                    child: Consumer<TetrisViewModel>(
                      builder: (context, tetris, child) {
                        return Stack(
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: TetrisConstants.rowCount *
                                  TetrisConstants.colCount,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: TetrisConstants.colCount,
                              ),
                              itemBuilder: (context, index) {
                                int row = index ~/ TetrisConstants.colCount;
                                int col = index % TetrisConstants.colCount;

                                Color? color = tetris.board[row][col];

                                if (color == null && tetris.isPlaying && !tetris.isGameOver) {
                                  for (var p in tetris.currentPiece) {
                                    if ((tetris.currentPosition.x + p.x) ==
                                            row &&
                                        (tetris.currentPosition.y + p.y) ==
                                            col) {
                                      color = tetris.currentPieceColor;
                                    }
                                  }
                                }
                                // -----------------------

                                if (color == null) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[100]!,
                                            width: 0.5)),
                                  );
                                }

                                return _buildBlock(color);
                              },
                            ),
                            if (tetris.isGameOver)
                              Container(
                                color: Colors.white.withOpacity(0.85),
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "GAME OVER",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Final Score: ${tetris.score}",
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // 3. CONTROLS
            Consumer<TetrisViewModel>(
              builder: (context, tetris, child) {
                if (!tetris.isPlaying) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                        onPressed: tetris.startGame,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[700],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Text(
                          tetris.isGameOver ? "RETRY" : "START GAME",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _controlButton(Icons.arrow_back, tetris.moveLeft),
                      _controlButton(Icons.rotate_right, tetris.rotate),
                      _controlButton(Icons.arrow_forward, tetris.moveRight),
                      _controlButton(Icons.arrow_downward, tetris.moveDown),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlock(Color color, {double size = 0}) {
    return Container(
      width: size > 0 ? size : null,
      height: size > 0 ? size : null,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          gradient: RadialGradient(
            colors: [color.withOpacity(0.6), color],
            center: const Alignment(-0.4, -0.4),
            radius: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 3,
            )
          ]),
    );
  }

  Widget _buildNextPiece(TetrominoType type, Color color) {
    List<List<int>> shape = TetrisConstants.shapes[type]!;

    return SizedBox(
      width: 48,
      height: 48,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 16,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) {
          int row = index ~/ 4;
          int col = index % 4;

          bool isOccupied = false;
          for (var point in shape) {
            if (point[0] == row && point[1] == col) {
              isOccupied = true;
              break;
            }
          }

          if (isOccupied) {
            return _buildBlock(color, size: 8);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _controlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.brown[50],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.brown[200]!)),
        child: Icon(icon, color: Colors.brown[800]),
      ),
    );
  }
}