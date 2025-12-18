part of 'pages.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  // Daftar icon/gambar yang ingin dipasangkan
  final List<String> images = ["❤️", "🐶", "🍊", "🐟", "⭐", "🍎", "🍉", "🦊"];

  late List<_CardModel> cards;

  _CardModel? firstSelected;
  _CardModel? secondSelected;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    _generateCards();
  }

  // Generate 16 cards → double images & shuffle
  void _generateCards() {
    List<_CardModel> temp = [];

    for (var img in images) {
      temp.add(_CardModel(image: img));
      temp.add(_CardModel(image: img));
    }

    temp.shuffle(Random());
    cards = temp;
  }

  void _onCardTap(_CardModel card) {
    if (waiting) return;
    if (card.isMatched || card.isFlipped) return;

    setState(() => card.isFlipped = true);

    if (firstSelected == null) {
      firstSelected = card;
    } else {
      secondSelected = card;
      waiting = true;

      Future.delayed(const Duration(milliseconds: 700), () {
        if (firstSelected!.image == secondSelected!.image) {
          firstSelected!.isMatched = true;
          secondSelected!.isMatched = true;
        } else {
          firstSelected!.isFlipped = false;
          secondSelected!.isFlipped = false;
        }

        setState(() {
          firstSelected = null;
          secondSelected = null;
          waiting = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Memory Game", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: cards.length,
          itemBuilder: (_, index) {
            return _buildMemoryCard(cards[index]);
          },
        ),
      ),
    );
  }

  Widget _buildMemoryCard(_CardModel card) {
    return GestureDetector(
      onTap: () => _onCardTap(card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched
              ? Colors.orange
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(1, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: card.isFlipped || card.isMatched
            ? Text(card.image, style: const TextStyle(fontSize: 36))
            : const Icon(
                Icons.face_6_outlined,
                size: 32,
                color: Colors.deepOrange,
              ),
      ),
    );
  }
}

// Model kartu
class _CardModel {
  final String image;
  late bool isFlipped;
  late bool isMatched;

  _CardModel({required this.image});
}
