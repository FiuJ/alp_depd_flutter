part of 'pages.dart';

class WordlePage extends StatefulWidget {
  const WordlePage({super.key});

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage> {
  final int gridSize = 10;

  List<List<String>> letters = [];
  List<List<bool>> selected = [];
  List<List<bool>> permanentlySelected = [];

  bool isDragging = false;
  List<Offset> currentPath = [];

  /// Word list yang harus dicari user
  List<String> targetWords = ["MOON", "LAMP", "APPLE"];
  List<String> foundWords = [];

  @override
  void initState() {
    super.initState();
    _generateEmptyGrid();
    _placeWords();
    _fillRemainingCells();
  }

  void _generateEmptyGrid() {
    letters = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => ""),
    );
    selected = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => false),
    );
    permanentlySelected = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => false),
    );
  }

  // ============================
  //    PLACE WORDS IN THE GRID
  // ============================
  void _placeWords() {
    final rand = Random();

    for (String word in targetWords) {
      bool placed = false;

      while (!placed) {
        int row = rand.nextInt(gridSize);
        int col = rand.nextInt(gridSize);

        // 8 arah
        List<List<int>> directions = [
          [1, 0], // down
          [-1, 0], // up
          [0, 1], // right
          [0, -1], // left
          [1, 1], // diagonal down-right
          [1, -1], // diagonal down-left
          [-1, 1], // diagonal up-right
          [-1, -1], // diagonal up-left
        ];

        var dir = directions[rand.nextInt(directions.length)];

        int endRow = row + dir[0] * (word.length - 1);
        int endCol = col + dir[1] * (word.length - 1);

        // Jika keluar grid → retry
        if (endRow < 0 ||
            endRow >= gridSize ||
            endCol < 0 ||
            endCol >= gridSize) {
          continue;
        }

        // Cek apakah posisi valid
        bool canPlace = true;
        for (int i = 0; i < word.length; i++) {
          int r = row + dir[0] * i;
          int c = col + dir[1] * i;

          if (letters[r][c].isNotEmpty &&
              letters[r][c] != word[i]) {
            canPlace = false;
            break;
          }
        }

        if (!canPlace) continue;

        // Tempatkan kata
        for (int i = 0; i < word.length; i++) {
          letters[row + dir[0] * i][col + dir[1] * i] = word[i];
        }

        placed = true;
      }
    }
  }

  // ============================
  //     FILL REMAINING LETTERS
  // ============================
  void _fillRemainingCells() {
    const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final rand = Random();

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (letters[r][c] == "") {
          letters[r][c] = alphabet[rand.nextInt(26)];
        }
      }
    }
  }

  // ============================
  //      WORD VALIDATION
  // ============================
  void _finalizeSelection() {
    String collected = "";
    for (var p in currentPath) {
      collected += letters[p.dx.toInt()][p.dy.toInt()];
    }

    // Validasi kata
    if (targetWords.contains(collected) &&
        !foundWords.contains(collected)) {
      foundWords.add(collected);

      // Kunci word yang benar
      for (var p in currentPath) {
        permanentlySelected[p.dx.toInt()][p.dy.toInt()] = true;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Found word: $collected!")),
      );
    }

    // Reset temporary selection
    currentPath.clear();
    setState(() {
      for (int r = 0; r < gridSize; r++) {
        for (int c = 0; c < gridSize; c++) {
          selected[r][c] = false;
        }
      }
    });
  }

  void _start(int r, int c) {
    setState(() {
      isDragging = true;
      currentPath.clear();
      currentPath.add(Offset(r.toDouble(), c.toDouble()));
      selected[r][c] = true;
    });
  }

  void _update(int r, int c) {
    if (!isDragging) return;

    Offset pos = Offset(r.toDouble(), c.toDouble());
    if (!currentPath.contains(pos)) {
      setState(() {
        currentPath.add(pos);
        selected[r][c] = true;
      });
    }
  }

  void _end() {
    setState(() => isDragging = false);
    _finalizeSelection();
  }

  // ============================
  //          UI
  // ============================
  @override
  Widget build(BuildContext context) {
    final colorCorrect = Colors.orange;
    final colorSelected = Colors.blue;
    final colorDefault = Colors.grey[300]!;

    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        title: const Text("Minigame 1 - Word Search"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          // WORD LIST (kata yang dicari)
          Wrap(
            spacing: 10,
            children: targetWords.map((w) {
              bool done = foundWords.contains(w);
              return Chip(
                label: Text(
                  w,
                  style: TextStyle(
                    color: done ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: done ? Colors.green : Colors.white,
              );
            }).toList(),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: Listener(
              onPointerUp: (_) => _end(),
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: gridSize * gridSize,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (ctx, index) {
                  int r = index ~/ gridSize;
                  int c = index % gridSize;

                  bool isCorrect = permanentlySelected[r][c];
                  bool isTemp = selected[r][c];

                  Color boxColor = isCorrect
                      ? colorCorrect
                      : isTemp
                          ? colorSelected
                          : colorDefault;

                  return GestureDetector(
                    onPanStart: (_) => _start(r, c),
                    onPanUpdate: (details) {
                      RenderBox box =
                          ctx.findRenderObject() as RenderBox;
                      Offset local =
                          box.globalToLocal(details.globalPosition);

                      double cellW = box.size.width / gridSize;
                      double cellH = box.size.height / gridSize;

                      int nr = (local.dy / cellH).floor();
                      int nc = (local.dx / cellW).floor();

                      if (nr >= 0 &&
                          nr < gridSize &&
                          nc >= 0 &&
                          nc < gridSize) {
                        _update(nr, nc);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          letters[r][c],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                isCorrect ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
