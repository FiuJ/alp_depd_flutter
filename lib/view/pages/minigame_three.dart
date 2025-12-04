import 'package:flutter/material.dart';

class MinigameThree extends StatelessWidget{
  const MinigameThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color:Colors.orange, width: 3),  
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/lounge.jpg',
                  fit: BoxFit.cover,
                  height: 220,
                  width: double.infinity,
                ),
              ),
            ),

            const SizedBox(height:30),

            const Text(
              "Guess The Place!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _LetterBox(letter: "S"),
                _LetterBox(letter: "I"),
                _LetterBox(letter: "F"),
                _LetterBox(letter: "T"),
              ],
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

class _LetterBox extends StatelessWidget {
  final String letter;
  const _LetterBox({required this.letter});

  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            letter,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            width: 35,
            height: 4,
            color:  Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}