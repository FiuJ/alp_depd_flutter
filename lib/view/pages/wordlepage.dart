part of 'pages.dart';

class WordlePage extends StatefulWidget {
  const WordlePage({super.key});

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage> {
  final int gridSize = 12;
  final int wordsCount = 6;

  late List<List<String>> letters;
  late List<List<bool>> tempSelected;
  late List<List<bool>> locked;

  bool isDragging = false;
  List<Offset> currentPath = [];
  Offset? dragDirection;

  List<String> wordBank = [
    "MOON", "LAMP", "APPLE", "TREE", "RIVER", "BREAD", "HOUSE", "CAT",
    "DOG", "BERRY", "ORANGE", "WATER", "MUSIC", "BRIGHT", "LIGHT", "SMILE",
    "GOLD", "SILVER", "EARTH", "PLANT", "STONE", "PHONE", "CLOCK", "TRAIN"
  ];
  List<String> targetWords = [];
  List<String> foundWords = [];

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _pickRandomWords();
    _generateEmptyGrid();
    _placeWords();
    _fillRemaining();
    setState(() {});
  }

  void _pickRandomWords() {
    final rand = Random();
    final shuffled = List<String>.from(wordBank)..shuffle(rand);
    targetWords = shuffled.where((w) => w.length <= gridSize).take(wordsCount).toList();
  }

  void _generateEmptyGrid() {
    letters = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ""));
    tempSelected = List.generate(gridSize, (_) => List.generate(gridSize, (_) => false));
    locked = List.generate(gridSize, (_) => List.generate(gridSize, (_) => false));
  }

  void _placeWords() {
    final rand = Random();
    final directions = [
      [1, 0], [-1, 0], [0, 1], [0, -1],
      [1, 1], [1, -1], [-1, 1], [-1, -1],
    ];

    for (String word in targetWords) {
      bool placed = false;
      int attempts = 0;

      while (!placed && attempts < 300) {
        attempts++;
        int r = rand.nextInt(gridSize);
        int c = rand.nextInt(gridSize);
        final dir = directions[rand.nextInt(directions.length)];

        int endR = r + dir[0] * (word.length - 1);
        int endC = c + dir[1] * (word.length - 1);

        if (endR < 0 || endR >= gridSize || endC < 0 || endC >= gridSize) continue;

        bool ok = true;
        for (int i = 0; i < word.length; i++) {
          int rr = r + dir[0] * i;
          int cc = c + dir[1] * i;
          if (letters[rr][cc] != "" && letters[rr][cc] != word[i]) {
            ok = false;
            break;
          }
        }
        if (!ok) continue;

        for (int i = 0; i < word.length; i++) {
          letters[r + dir[0] * i][c + dir[1] * i] = word[i];
        }
        placed = true;
      }
    }
  }

  void _fillRemaining() {
    const alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final rand = Random();

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (letters[r][c] == "") {
          letters[r][c] = alpha[rand.nextInt(26)];
        }
      }
    }
  }

  // ======================================================================================
  // SELECTION
  // ======================================================================================

  void _startSelection(int r, int c) {
    setState(() {
      isDragging = true;
      currentPath = [Offset(r.toDouble(), c.toDouble())];
      dragDirection = null;
      tempSelected[r][c] = true;
    });
  }

  void _updateSelection(int r, int c) {
    if (!isDragging) return;

    final pos = Offset(r.toDouble(), c.toDouble());

    if (currentPath.length == 1 && dragDirection == null) {
      final first = currentPath.first;
      int dr = r - first.dx.toInt();
      int dc = c - first.dy.toInt();
      if (dr == 0 && dc == 0) return;

      dragDirection = Offset(
        dr == 0 ? 0 : dr > 0 ? 1 : -1,
        dc == 0 ? 0 : dc > 0 ? 1 : -1,
      );
    }

    if (dragDirection != null) {
      final start = currentPath.first;
      final step = currentPath.length;

      final expectedR = start.dx.toInt() + dragDirection!.dx.toInt() * step;
      final expectedC = start.dy.toInt() + dragDirection!.dy.toInt() * step;

      if (r != expectedR || c != expectedC) return;
    }

    if (!currentPath.contains(pos)) {
      setState(() {
        currentPath.add(pos);
        tempSelected[r][c] = true;
      });
    }
  }

  void _endSelection() {
    if (!isDragging) return;

    isDragging = false;

    String collected = "";
    for (var p in currentPath) {
      collected += letters[p.dx.toInt()][p.dy.toInt()];
    }

    bool matched = false;

    for (final w in targetWords) {
      if (collected == w || collected == w.split('').reversed.join()) {
        matched = true;

        if (!foundWords.contains(w)) {
          foundWords.add(w);

          for (var p in currentPath) {
            locked[p.dx.toInt()][p.dy.toInt()] = true;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Kata ditemukan: $w")),
          );
        }
      }
    }

    if (!matched) {
      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() {
          for (var p in currentPath) tempSelected[p.dx.toInt()][p.dy.toInt()] = false;
          currentPath.clear();
          dragDirection = null;
        });
      });
    } else {
      setState(() {
        currentPath.clear();
        dragDirection = null;
      });
    }

    setState(() {
      for (int r = 0; r < gridSize; r++) {
        for (int c = 0; c < gridSize; c++) {
          if (!locked[r][c]) tempSelected[r][c] = false;
        }
      }
    });
  }

  // ======================================================================================
  // UI + GRID OPTIMIZED
  // ======================================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Colors.deepOrange;
    final highlight = Colors.blue.shade400;
    final foundColor = Colors.orange;
    final defaultColor = Colors.grey.shade300;

    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        backgroundColor: theme,
        foregroundColor: Colors.white,
        title: const Text("Minigame 1 - Word Search"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // WORD LIST
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: targetWords.map((w) {
                  final found = foundWords.contains(w);
                  return Chip(
                    label: Text(
                      w,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: found ? Colors.white : Colors.black87,
                      ),
                    ),
                    backgroundColor: found ? Colors.green : Colors.white,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // =================== GRID AREA (optimized) ===================
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final available = min(constraints.maxWidth, constraints.maxHeight * 0.80);
                final totalGap = (gridSize - 1) * 6;
                final tileSize = (available - totalGap) / gridSize;

                return Center(
                  child: Container(
                    width: tileSize * gridSize + totalGap,
                    height: tileSize * gridSize + totalGap,
                    key: _gridKey,
                    child: Listener(
                      onPointerUp: (_) => _endSelection(),
                      child: GestureDetector(
                        onPanStart: (e) => _handleGesturePosition(e.localPosition, tileSize),
                        onPanUpdate: (e) => _handleGesturePosition(e.localPosition, tileSize),
                        onPanEnd: (_) => _endSelection(),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridSize,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: gridSize * gridSize,
                          itemBuilder: (ctx, i) {
                            final r = i ~/ gridSize;
                            final c = i % gridSize;

                            final isLocked = locked[r][c];
                            final isTemp = tempSelected[r][c];
                            final isCurrent = currentPath.contains(Offset(r.toDouble(), c.toDouble()));

                            final bg = isLocked
                                ? foundColor
                                : (isTemp || isCurrent ? highlight : defaultColor);

                            return _buildTile(r, c, bg, tileSize);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: theme,
        onPressed: () {
          foundWords.clear();
          _initGame();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  final GlobalKey _gridKey = GlobalKey();

  // ======================================================================================
  // TILE
  // ======================================================================================

  Widget _buildTile(int r, int c, Color bg, double tileSize) {
    final isLocked = locked[r][c];

    return GestureDetector(
      onTapDown: (_) => _startSelection(r, c),
      onTapUp: (_) => _endSelection(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Center(
          child: Text(
            letters[r][c],
            style: TextStyle(
              fontSize: tileSize * 0.42,
              fontWeight: FontWeight.w700,
              color: isLocked ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================================================
  // GESTURE → TILE INDEX FIXED
  // ======================================================================================

  void _handleGesturePosition(Offset pos, double tileSize) {
    final col = (pos.dx / (tileSize + 6)).floor();
    final row = (pos.dy / (tileSize + 6)).floor();

    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      _updateSelection(row, col);
    }
  }
}
