import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  int level = 1;
  late int gridColumns;
  late int gridRows;
  late int squaresToRemember;
  List<int> pattern = [];
  List<int> userSelections = [];
  bool showPattern = true;
  bool gameOver = false;
  Timer? patternTimer;
  Timer? gameTimer;
  int timeRemaining = 30;
  int point = 0;
  String _user_id = "";

  void _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _user_id = prefs.getString("user_id") ?? ''; 
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserId(); 
    setupLevel();
  }

  void setupLevel() {
    gridColumns = 3;
    gridRows = 3 + (level - 1); // Baris bertambah tiap level
    squaresToRemember = level + 2; // Persegi yang diingat bertambah tiap level
    pattern = generateRandomPattern();
    userSelections = [];
    showPattern = true;
    timeRemaining = 30;
    startPatternTimer();
  }

  List<int> generateRandomPattern() {
    Random random = Random();
    List<int> randomPattern = [];
    while (randomPattern.length < squaresToRemember) {
      int randomIndex = random.nextInt(gridColumns * gridRows);
      if (!randomPattern.contains(randomIndex)) {
        randomPattern.add(randomIndex);
      }
    }
    return randomPattern;
  }

  void startPatternTimer() {
    patternTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        showPattern = false;
        startGameTimer();
      });
    });
  }

  void startGameTimer() {
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeRemaining--;
        if (timeRemaining == 0) {
          timer.cancel();
          gameOver = true;
          showGameOverMessage();
        }
      });
    });
  }

  void checkSelection(int index) {
    if (pattern.contains(index)) {
      userSelections.add(index);
      if (userSelections.length == pattern.length) {
        gameTimer?.cancel();
        setState(() {
          if (level < 5) {
            level++;
            setupLevel();
            point++;
          } else {
            point++;
            showWinMessage();
          }
        });
      }
    } else {
      gameTimer?.cancel();
      setState(() {
        gameOver = true;
        showGameOverMessage();
      });
    }
  }

  Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? highScores = prefs.getStringList('high_scores') ?? [];
    highScores.add('$_user_id,$point');
    await prefs.setStringList('high_scores', highScores);
  }

  void showGameOverMessage() {
    saveHighScore();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Game Over!, $_user_id'),
        content: Text('You made a wrong guess. Point(s): $point'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  void showWinMessage() {
    saveHighScore();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Congratulations $_user_id!'),
        content: Text('You completed all levels! Point(s): $point'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              point = 0;
              resetGame();
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      level = 1;
      point = 0;
      gameOver = false;
      setupLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double gridSize = min(screenWidth, screenHeight) - 32;
    double itemSize = gridSize / gridColumns;

    return Scaffold(
      appBar: AppBar(title: Text('Memory Game - Level $level')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridColumns,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: gridColumns * gridRows,
              itemBuilder: (context, index) {
                bool isPatternSquare = pattern.contains(index);
                bool isSelected = userSelections.contains(index);
                return GestureDetector(
                  onTap: !showPattern && !gameOver && !isSelected
                      ? () => checkSelection(index)
                      : null,
                  child: Container(
                    width: itemSize,
                    height: itemSize,
                    decoration: BoxDecoration(
                      color: showPattern
                          ? (isPatternSquare ? Colors.teal : Colors.grey)
                          : (isSelected ? Colors.green : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.all(4),
                  ),
                );
              },
              padding: EdgeInsets.all(8),
            ),
          ),
          if (!showPattern)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Time remaining: $timeRemaining seconds',
                style: TextStyle(fontSize: 20),
              ),
            ),
        ],
      ),
    );
  }
}
