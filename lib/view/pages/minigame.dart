part of 'pages.dart';

class Minigame extends StatefulWidget {
  const Minigame({super.key});

  @override
  State<Minigame> createState() => _MinigameState();
}

class _MinigameState extends State<Minigame> {
  final Color themeColor = Colors.deepOrange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.background,

      appBar: AppBar(
        title: const Text(
          "Minigame",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Style.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildGameCard(
              title: "Bubble Shooter",
              image: "assets/images/Bubble.webp",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => BubbleGameViewModel(),
                      child: const BubbleGamePage(),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            _buildGameCard(
              title: "Tetris",
              image: "assets/images/Tetris.webp",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TetrisView()),
                );
              },
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // ---------- GAME CARD UI ----------
  Widget _buildGameCard({
    required String title,
    required String image,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: themeColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              offset: const Offset(2, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Title Container
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: themeColor, width: 1.5),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
