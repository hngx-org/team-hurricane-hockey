import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_hurricane_hockey/constants.dart';
import 'package:team_hurricane_hockey/models/player.dart';
import 'package:team_hurricane_hockey/models/puck.dart';
import 'package:team_hurricane_hockey/screens/widgets/player.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // player 1 & 2 and ball variables
  Player player1 = Player(color: Colors.red, name: "red");
  Player player2 = Player(name: "blue", color: Colors.blue);
  Puck ball = Puck(name: "ball", color: Colors.white);

  // ball attributes
  late double xSpeed;
  late double ySpeed;

  // table attributes
  late final double tableHeight;
  late final double tableWidth;

  // Start text attributes
  String textStart = 'Tap to start!';
  final textStartHeight = 120.0;
  final textStartWidth = 480.0;
  double textStartFontSize = 30.0;
  late final double textStartTop;
  late final double textStartLeft;

  // global attributes
  late String turn;
  bool gameIsStarted = false;
  bool gameIsFinished = false;
  bool showStartText = true;
  late double distanceBall2P1;
  late double distanceBall2P2;
  int gameEndsAt = 10;

  double pythagoras(double a, double b) {
    return sqrt(pow(a, 2).toDouble() + pow(b, 2).toDouble());
  }

  void nextRound(String player) {
    player == player1.name ? player1.score++ : player2.score++;
    turn = player;
    xSpeed = 0;
    ySpeed = 0;
    showStartText = true;
    if (player1.score == gameEndsAt) {
      textStart = "${player1.name} Wins";
      textStartFontSize *= 2;
      turn = player1.name;
      gameIsFinished = true;
    } else if (player2.score == gameEndsAt) {
      textStart = "${player2.name} Wins";
      textStartFontSize *= 2;
      turn = player2.name;
      gameIsFinished = true;
    }
    ball.left = (tableWidth / 2) - ballRadius;
    ball.top = (tableHeight / 2) - ballRadius;
  }

  final goalWidth = 100.0;
  void doTheMathWork() {
    player1.right = player1.left + playerSize;
    player1.bottom = player1.top + playerSize;
    player1.centerX = player1.left + playerRadius;
    player1.centerY = player1.top + playerRadius;
    player2.right = player2.left + playerSize;
    player2.bottom = player2.top + playerSize;
    player2.centerX = player2.left + playerRadius;
    player2.centerY = player2.top + playerRadius;
    ball.right = ball.left + ball.size;
    ball.bottom = ball.top + ball.size;
    ball.centerX = ball.left + ballRadius;
    ball.centerY = ball.top + ballRadius;

    // Calculate the left and right bounds of the goalpost.
    double goalLeft1 = (tableWidth - goalWidth) / 2;
    double goalRight1 = goalLeft1 + goalWidth;
    double goalLeft2 = tableWidth / 2 - goalWidth / 2;
    double goalRight2 = goalLeft2 + goalWidth;

    // Check if the ball is inside the goalpost area.
    if ((ball.top <= 0 || ball.bottom >= tableHeight) &&
        ((ball.centerX >= goalLeft1 && ball.centerX <= goalRight1) ||
            (ball.centerX >= goalLeft2 && ball.centerX <= goalRight2))) {
    } else if (ball.top <= 0 || ball.bottom >= tableHeight) {
      ySpeed = -ySpeed;
    } else {
      distanceBall2P1 = pythagoras(
          ball.centerX - player1.centerX, ball.centerY - player1.centerY);
      distanceBall2P2 = pythagoras(
          ball.centerX - player2.centerX, ball.centerY - player2.centerY);

      // Player1 (top player) calculations
      if (distanceBall2P1 <= playerRadius + ballRadius) {
        xSpeed =
            (ball.centerX - player1.centerX) / (ball.centerY - player1.centerY);
        if (player1.shotX != 0) {
          xSpeed = 5 * player1.shotX;
          ySpeed = 5 * player1.shotY;
        }
        xSpeed = xSpeed > 10 ? 10 : xSpeed;
        ySpeed = 1 / xSpeed.abs();
        ySpeed = ySpeed > 5 ? 5 : ySpeed;
      }

      // Player2 (bottom player) calculations
      else if (distanceBall2P2 <= playerRadius + ballRadius) {
        xSpeed = -(ball.centerX - player2.centerX) /
            (ball.centerY - player2.centerY);
        if (player2.shotX != 0) {
          xSpeed = 5 * player2.shotX;
          ySpeed = 5 * player2.shotY;
        }
        xSpeed = xSpeed < -10 ? -10 : xSpeed;
        ySpeed = -1 / xSpeed.abs();
        ySpeed = ySpeed < (-5) ? (-5) : ySpeed;
      }
    }
  }

  // AI Logic for player2 (defending its house)
  void defendGoal() {
    // Calculate the desired defensive position for player2.
    double desiredX = ball.centerX;

    // Adjust desiredX to stay within the game table boundaries.
    desiredX = desiredX < player2.size / 2
        ? player2.size / 2
        : desiredX > tableWidth - player2.size / 2
            ? tableWidth - player2.size / 2
            : desiredX;

    // Move player2 towards the desiredX position.
    if (player2.centerX < desiredX) {
      player2.left += 1.0; // Adjust the speed of player2's movement.
    } else if (player2.centerX > desiredX) {
      player2.left -= 1.0; // Adjust the speed of player2's movement.
    }

    // Ensure player2 stays within the horizontal boundaries.
    player2.left = player2.left < 0 ? 0 : player2.left;
    player2.left = player2.left > (tableWidth - player2.size)
        ? (tableWidth - player2.size)
        : player2.left;

    setState(() {}); // Update the UI to reflect player2's new position.
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    double sWidth = MediaQuery.of(context).size.width;
    double sHeight = MediaQuery.of(context).size.height;

    if (!gameIsStarted) {
      player1.score = 0;
      player2.score = 0;
      tableWidth = sWidth - playerSize;
      tableHeight = sHeight - 4 * playerSize;
      player1.left = tableWidth / 2 - playerRadius;
      player1.top = 0;
      player2.left = tableWidth /2 - playerRadius;
      player2.top = tableHeight - playerSize;
      textStartLeft = tableWidth / 2 - textStartWidth / 2;
      textStartTop = tableHeight / 2 - textStartHeight / 2;
      ball.left = tableWidth / 2 - ballRadius;
      ball.top = tableHeight / 2 - ballRadius;
      turn = Random().nextBool() ? player1.name : player2.name;
      gameIsStarted = true;
    } else {
      defendGoal();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            color: Colors.green,
            width: tableWidth,
            height: tableHeight,
            child: Stack(
              children: [
                // The table which is stateless and does not move
                const Positioned(
                  child: Column(
                    children: [
                      SizedBox(
                        height: playerSize * 3,
                      ),
                      Divider(),
                      Expanded(child: SizedBox()),
                      Divider(color: Colors.white, thickness: 2),
                      Expanded(child: SizedBox()),
                      Divider(),
                      SizedBox(
                        height: playerSize * 3,
                      ),
                    ],
                  ),
                ),

                // Goal Area Container with Borders
                Positioned(
                  left: 0, // Align to the left edge of the table
                  top: 0, // Align to the top edge of the table
                  child: Container(
                    width: tableWidth,
                    height: tableHeight,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.0),
                    ),
                  ),
                ),

                // Goalpost 1
                Positioned(
                  left: (tableWidth - goalWidth) / 2, // Centered
                  top: 0, // Align to the top
                  child: Container(
                    width: goalWidth,
                    height: 2,
                    color: Colors.yellow, // Transparent background
                  ),
                ),

                // Goalpost 2
                Positioned(
                  left: (tableWidth - goalWidth) / 2, // Centered
                  bottom: 0, // Align to the top
                  child: Container(
                    width: goalWidth,
                    height: 2,
                    color: Colors.yellow, // Transparent background
                  ),
                ),

                // player1 (top player)
                !gameIsFinished
                    ? Positioned(
                        left: player1.left,
                        top: player1.top,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            player1.left += details.delta.dx;
                            player1.left = player1.left > 0 ? player1.left : 0;
                            player1.left =
                                player1.left < (tableWidth - playerSize)
                                    ? player1.left
                                    : (tableWidth - playerSize);
                            player1.shotX = details.delta.dx;
                            player1.top += details.delta.dy;
                            player1.top = player1.top > 0 ? player1.top : 0;
                            player1.top = player1.top < playerSize * 2
                                ? player1.top
                                : playerSize * 2;
                            player1.shotY = details.delta.dy;
                            setState(() {});
                          },
                          onPanEnd: (details) {
                            player1.shotX = 0;
                            player1.shotY = 0;
                            setState(() {});
                          },
                          child: PlayerChip(player: player1),
                        ),
                      )
                    : const SizedBox(),

                // player2 (bottom player)
                !gameIsFinished
                    ? Positioned(
                        left: player2.left,
                        top: player2.top,
                        child: PlayerChip(
                            player:
                                player2), // Player2 is now controlled by AI.
                      )
                    : const SizedBox(),

                // ball and the inside text
                !gameIsFinished
                    ? Positioned(
                        left: ball.left,
                        top: ball.top,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(ballRadius),
                          child: Container(
                            width: ballSize,
                            height: ballSize,
                            color: ball.color,
                            child: Visibility(
                              visible: showStartText,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RotatedBox(
                                    quarterTurns: 2,
                                    child: Text(
                                      "You: ${player1.score}",
                                      style: const TextStyle(
                                        fontSize: ballSize / 4,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "You: ${player2.score}",
                                    style: const TextStyle(
                                      fontSize: ballSize / 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),

                // text and tapping to start
                Positioned(
                  width: textStartWidth,
                  height: textStartHeight,
                  left: textStartLeft,
                  top: textStartTop,
                  child: Center(
                    child: Visibility(
                      visible: showStartText,
                      child: TextButton(
                        child: RotatedBox(
                          quarterTurns: turn == player1.name ? 2 : 0,
                          child: Text(
                            textStart,
                            style: TextStyle(
                                fontSize: textStartFontSize,
                                color: turn == player1.name
                                    ? player1.color
                                    : player2.color),
                          ),
                        ),
                        onPressed: () async {
                          if (gameIsFinished) {
                            return;
                          }
                          xSpeed = Random().nextBool()
                              ? (Random().nextInt(2) + 1).toDouble()
                              : -(Random().nextInt(2) + 1).toDouble();
                          ySpeed = turn == player1.name
                              ? (Random().nextInt(1) + 1).toDouble()
                              : -(Random().nextInt(1) + 1).toDouble();
                          showStartText = false;
                          do {
                            ball.left += xSpeed;
                            ball.top += ySpeed;
                            if (ball.left > tableWidth - ballSize) {
                              xSpeed = (-1) * (xSpeed.abs());
                            } else if (ball.left <= 0) {
                              xSpeed = xSpeed.abs();
                            }
                            if (ball.top > tableHeight - ballSize / 3) {
                              nextRound(player1.name);
                              break;
                            } else if (ball.top <= 0 - ballSize * 2 / 3) {
                              nextRound(player2.name);
                              break;
                            }
                            doTheMathWork();
                            await Future.delayed(
                                const Duration(milliseconds: 1));
                            setState(() {});
                          } while (true);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
