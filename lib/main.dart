import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> words = [
    'ESIH - Nou tout ladann',
    'Mize - Nou tout ap viv ladann',
    'Ariel - Un ssassin du president au pouvoir.',
    'Laptop - Outil du developpeur',
    'Ronaldo - Goat du football.',
    'Messi - Le chouchou de la fifa .',
  ];
  late String chosenWord;
  late String displayedWord;
  final Set<String> guessedLetters = {};
  int chances = 5;

  @override
  void initState() {
    super.initState();
    int index = Random().nextInt(words.length);
    chosenWord = words[index].split(' - ').first.toLowerCase();
    displayedWord = '*' * chosenWord.length;
  }

  void guessLetter(String letter) {
    setState(() {
      if (chosenWord.contains(letter)) {
        displayedWord = displayedWord.split('').asMap().entries.map((entry) {
          int index = entry.key;
          String char = entry.value;
          return chosenWord[index] == letter ? letter : char;
        }).join();
      } else {
        chances--;
      }
      guessedLetters.add(letter);
      checkGameStatus();
    });
  }

  void resetGame() {
    setState(() {
      int index = Random().nextInt(words.length);
      chosenWord = words[index].split(' - ').first.toLowerCase();
      displayedWord = '*' * chosenWord.length;
      guessedLetters.clear();
      chances = 5;
    });
  }

  void checkGameStatus() {
    if (displayedWord == chosenWord || chances == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            resetGame,
            chances,
            displayedWord == chosenWord,
            words
                .firstWhere((word) =>
                    word.split(' - ').first.toLowerCase() ==
                    chosenWord.toLowerCase())
                .split(' - ')
                .last,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star),
            SizedBox(width: 5.0),
            Text(
              '$chances',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Devine mo ki kache an',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    displayedWord.toUpperCase(),
                    style: TextStyle(fontSize: 32),
                  ),
                  SizedBox(height: 10),
                  Text(
                    words
                        .firstWhere((word) =>
                            word.split(' - ').first.toLowerCase() ==
                            chosenWord.toLowerCase())
                        .split(' - ')
                        .last,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey[300],
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buildKeyboardRow(0, 9),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buildKeyboardRow(9, 17),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buildKeyboardRow(17, 26),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildKeyboardRow(int startIndex, int endIndex) {
    List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
    List<Widget> rowChildren = [];
    for (int i = startIndex; i < endIndex; i++) {
      String letter = alphabet[i];
      rowChildren.add(
        ElevatedButton(
          onPressed: () {
            if (!guessedLetters.contains(letter)) {
              guessLetter(letter);
            }
          },
          child: Text(letter.toUpperCase()),
        ),
      );
    }
    return rowChildren;
  }
}

class ResultScreen extends StatelessWidget {
  final Function() resetGame;
  final int chancesRemaining;
  final bool isWinner;
  final String hint;

  ResultScreen(this.resetGame, this.chancesRemaining, this.isWinner, this.hint);

  @override
  Widget build(BuildContext context) {
    String resultMessage = isWinner ? 'Bravo! Ou Genyen!' : 'Oooops! Ou Pedi!';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              resultMessage,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Indis lan: $hint',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen(),)); // Retour à l'écran d'accueil
                  },
                  child: Text('Jwe Anko'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Kite'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
