import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Snake Game',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> snakePosition = [24, 44, 64];
  int foodLocation = Random().nextInt(700);
  bool gameStarted = false;
  List<int> totalSpot = List.generate(760, (index) => index);
  int score = 0;

  startGame() {
    setState(() {
      gameStarted = true;
      snakePosition = [24, 44, 64];
      score = 0;
      Timer.periodic(const Duration(milliseconds: 300), (timer) {
        updateSnake();
        if (gameOver()) {
          gameOverAlert();
          timer.cancel();
        }
      });
    });
  }

  updateSnake() {
    setState(() {
      final lastPosition = snakePosition.last;
      switch (direction) {
        case Direction.down:
          if (lastPosition > 740) {
            snakePosition.add(lastPosition - 760 + 20);
          } else {
            snakePosition.add(lastPosition + 20);
          }
          break;
        case Direction.up:
          if (lastPosition < 20) {
            snakePosition.add(lastPosition + 760 - 20);
          } else {
            snakePosition.add(lastPosition - 20);
          }
          break;
        case Direction.right:
          if ((lastPosition + 1) % 20 == 0) {
            snakePosition.add(lastPosition + 1 - 20);
          } else {
            snakePosition.add(lastPosition + 1);
          }
          break;
        case Direction.left:
          if (lastPosition % 20 == 0) {
            snakePosition.add(lastPosition - 1 + 20);
          } else {
            snakePosition.add(lastPosition - 1);
          }
          break;
        default:
      }
      if (snakePosition.last == foodLocation) {
        totalSpot.removeWhere((element) => snakePosition.contains(element));
        foodLocation = totalSpot[Random().nextInt(totalSpot.length - 1)];
        score++;
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    final copyList = List.from(snakePosition);
    return snakePosition.length > copyList.toSet().length;
  }

  gameOverAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score is $score'),
          actions: [
            TextButton(
              onPressed: () {
                startGame();
                Navigator.of(context).pop(true);
              },
              child: const Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                gameStarted = false;
                snakePosition.clear();
              });
            },
            icon: const Icon(Icons.stop),
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (!gameStarted) return;
          if (direction != Direction.up && details.delta.dy > 0) {
            direction = Direction.down;
          }
          if (direction != Direction.down && details.delta.dy < 0) {
            direction = Direction.up;
          }
        },
        onHorizontalDragUpdate: (details) {
          if (!gameStarted) return;
          if (direction != Direction.left && details.delta.dx > 0) {
            direction = Direction.right;
          }
          if (direction != Direction.right && details.delta.dx < 0) {
            direction = Direction.left;
          }
        },
        child: Stack(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 760,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20,
              ),
              itemBuilder: (context, index) {
                if (snakePosition.contains(index)) {
                  return Container(
                    color: Colors.green,
                    margin: const EdgeInsets.all(1),
                  );
                }
                if (index == foodLocation) {
                  return Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.all(1),
                    child: Center(
                      child: Icon(
                        Icons.circle,
                        size: 15,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(1),
                );
              },
            ),
            if (!gameStarted)
              Center(
                child: ElevatedButton(
                  onPressed: startGame,
                  child: const Text('Start Game'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum Direction { up, down, left, right }
Direction direction = Direction.down;

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  List<int> snakePosition = [24, 44, 64];
  int foodLocation = Random().nextInt(700);
  bool gameStarted = false;
  List<int> totalSpot = List.generate(760, (index) => index);
  int score = 0;

  startGame() {
    setState(() {
      gameStarted = true;
      snakePosition = [24, 44, 64];
      score = 0;
      Timer.periodic(const Duration(milliseconds: 300), (timer) {
        updateSnake();
        if (gameOver()) {
          gameOverAlert();
          timer.cancel();
        }
      });
    });
  }

  updateSnake() {
    setState(() {
      final lastPosition = snakePosition.last;
      switch (direction) {
        case Direction.down:
          if (lastPosition > 740) {
            snakePosition.add(lastPosition - 760 + 20);
          } else {
            snakePosition.add(lastPosition + 20);
          }
          break;
        case Direction.up:
          if (lastPosition < 20) {
            snakePosition.add(lastPosition + 760 - 20);
          } else {
            snakePosition.add(lastPosition - 20);
          }
          break;
        case Direction.right:
          if ((lastPosition + 1) % 20 == 0) {
            snakePosition.add(lastPosition + 1 - 20);
          } else {
            snakePosition.add(lastPosition + 1);
          }
          break;
        case Direction.left:
          if (lastPosition % 20 == 0) {
            snakePosition.add(lastPosition - 1 + 20);
          } else {
            snakePosition.add(lastPosition - 1);
          }
          break;
        default:
      }
      if (snakePosition.last == foodLocation) {
        totalSpot.removeWhere((element) => snakePosition.contains(element));
        foodLocation = totalSpot[Random().nextInt(totalSpot.length - 1)];
        score++;
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    final copyList = List.from(snakePosition);
    return snakePosition.length > copyList.toSet().length;
  }

  gameOverAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score is $score'),
          actions: [
            TextButton(
              onPressed: () {
                startGame();
                Navigator.of(context).pop(true);
              },
              child: const Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                gameStarted = false;
                snakePosition.clear();
              });
            },
            icon: const Icon(Icons.stop),
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (!gameStarted) return;
          if (direction != Direction.up && details.delta.dy > 0) {
            direction = Direction.down;
          }
          if (direction != Direction.down && details.delta.dy < 0) {
            direction = Direction.up;
          }
        },
        onHorizontalDragUpdate: (details) {
          if (!gameStarted) return;
          if (direction != Direction.left && details.delta.dx > 0) {
            direction = Direction.right;
          }
          if (direction != Direction.right && details.delta.dx < 0) {
            direction = Direction.left;
          }
        },
        child: Stack(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 760,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20,
              ),
              itemBuilder: (context, index) {
                if (snakePosition.contains(index)) {
                  return Container(
                    color: Colors.green,
                    margin: const EdgeInsets.all(1),
                  );
                }
                if (index == foodLocation) {
                  return Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.all(1),
                    child: Center(
                      child: Icon(
                        Icons.circle,
                        size: 15 + (score * 2).toDouble(),
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(1),
                );
              },
            ),
            if (!gameStarted)
              Center(
                child: ElevatedButton(
                  onPressed: startGame,
                  child: const Text('Start Game'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

