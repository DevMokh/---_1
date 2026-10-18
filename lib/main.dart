
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyGame());

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random random = Random();
  Timer? timer;

  double playerX = 0.5;
  double itemX = 0.5;
  double itemY = 0.1;
  bool bomb = false;
  bool gameOver = false;
  int score = 0;
  int lives = 3;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer?.cancel();
    playerX = 0.5;
    itemX = random.nextDouble() * 0.9;
    itemY = 0.1;
    score = 0;
    lives = 3;
    bomb = false;
    gameOver = false;

    timer = Timer.periodic(
      const Duration(milliseconds: 35),
      (t) {
        if (!mounted || gameOver) return;

        setState(() {
          itemY += 0.012;

          if (itemY > 0.82 &&
              (itemX - playerX).abs() < 0.13) {
            if (bomb) {
              lives--;
              if (lives <= 0) gameOver = true;
            } else {
              score += 10;
            }
            newItem();
          } else if (itemY > 1.0) {
            newItem();
          }
        });
      },
    );
  }

  void newItem() {
    itemX = random.nextDouble() * 0.9;
    itemY = 0.05;
    bomb = random.nextInt(4) == 0;
  }

  void movePlayer(double direction) {
    if (gameOver) return;
    setState(() {
      playerX = (playerX + direction * 0.07)
          .clamp(0.05, 0.95)
          .toDouble();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101526),
      appBar: AppBar(
        title: const Text('جامع العملات'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'النقاط: $score',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'الأرواح: $lives',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                return Stack(
                  children: [
                    Positioned(
                      left: itemX * w,
                      top: itemY * h,
                      child: Text(
                        bomb ? '💣' : '🪙',
                        style: const TextStyle(
                          fontSize: 34,
                        ),
                      ),
                    ),
                    Positioned(
                      left: playerX * w - 22,
                      top: h * 0.85,
                      child: const Text(
                        '🚀',
                        style: TextStyle(fontSize: 44),
                      ),
                    ),
                    if (gameOver)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'انتهت اللعبة!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                ),
                              ),
                              Text(
                                'نقاطك: $score',
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 22,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(startGame);
                                },
                                child: const Text('العب تاني'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => movePlayer(-1),
                  child: const Text(
                    '⬅️ شمال',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => movePlayer(1),
                  child: const Text(
                    'يمين ➡️',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
