import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_hurricane_hockey/constants.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/models/player.dart';
import 'package:team_hurricane_hockey/models/puck.dart';
import 'package:team_hurricane_hockey/screens/widgets/center_circe.dart';
import 'package:team_hurricane_hockey/screens/widgets/player.dart';
import 'package:team_hurricane_hockey/screens/widgets/spaces.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  const GameScreen({
    Key? key,
    required this.gameMode,
  }) : super(key: key);
  static const routeName = 'gameScreen';

  @override
  State<GameScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
  }

  // player 1 & 2 and ball variables
  Player player1 = Player(
    color: Colors.red,
    name: "red",
  );
  Player player2 = Player(
    name: "blue",
    color: Colors.blue,
  );
  Puck ball = Puck(
    name: "ball",
    color: Colors.black,
  );

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
  Offset? previousPoint;

  double pythagoras(double a, double b) {
    return math.sqrt(math.pow(a, 2).toDouble() + math.pow(b, 2).toDouble());
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
    ball.left = (MediaQuery.of(context).size.width / 2) - ballRadius;
    ball.top = (MediaQuery.of(context).size.height / 2) - ballRadius - 50;
  }

  final goalWidth = 100.0;
  void doTheMathWork() async {
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
    double goalLeft1 = (MediaQuery.of(context).size.width - goalWidth) / 2;
    double goalRight1 = goalLeft1 + goalWidth;
    double goalLeft2 = MediaQuery.of(context).size.width / 2 - goalWidth / 2;
    double goalRight2 = goalLeft2 + goalWidth;

    // Check if the ball is inside the goalpost area.
    if ((ball.top <= 0 || ball.bottom >= tableHeight) &&
        ((ball.centerX >= goalLeft1 && ball.centerX <= goalRight1) || (ball.centerX >= goalLeft2 && ball.centerX <= goalRight2))) {
    } else if (ball.top <= 0 || ball.bottom >= tableHeight) {
      ySpeed = -ySpeed;
    } else {
      distanceBall2P1 = pythagoras(
        ball.centerX - player1.centerX,
        ball.centerY - player1.centerY,
      );
      distanceBall2P2 = pythagoras(
        ball.centerX - player2.centerX,
        ball.centerY - player2.centerY,
      );

      // Player1 (top player) calculations
      if (distanceBall2P1 <= playerRadius + ballRadius) {
        handlePaddleCollision(player1);
      }

      // Player2 (bottom player) calculations
      else if (distanceBall2P2 <= playerRadius + ballRadius) {
        handlePaddleCollision(player2);
      }
    }
  }

  // AI Logic for player2 (defending its house)
  void defendGoal() {
    // Calculate the desired defensive position for the computer player based on the ball's position.
    double desiredX = ball.centerX;
    double desiredY = ball.centerY;

    // Adjust desiredX to stay within the computer player's half of the field horizontally.
    double minX = 0;
    double maxX = tableWidth - (player1.size);

    desiredX = desiredX.clamp(minX, maxX);
    // Adjust desiredY to stay within the computer player's half of the field vertically.
    double minY = 0; // Adjust this value as needed.
    double maxY = (tableHeight - 100) / 2;
    desiredY = desiredY.clamp(minY, maxY);

    // Move the computer player's paddle towards the desired position.
    if (player1.centerX < desiredX) {
      if (player1.left < maxX) {
        player1.left += 2.0; // Adjust the speed of the computer player's horizontal movement.
      }
    } else if (player1.centerX > desiredX) {
      if (player1.left < 8) {
        return;
      }

      player1.left -= 2.0; // Adjust the speed of the computer player's horizontal movement.
    }

    previousPoint = Offset(player1.left, 0);

    if (player1.centerY < desiredY) {
      player1.top += 1.0; // Adjust the speed of the computer player's vertical movement.
    } else if (player1.centerY > desiredY) {
      player1.top -= 1.0; // Adjust the speed of the computer player's vertical movement.
    }

    previousPoint = Offset(player1.left, player1.top);

    // Ensure the computer player's paddle stays within its half of the field horizontally and vertically.
    player1.top = player1.top.clamp(minY, maxY);

    // Update the UI to reflect the computer player's new position.
    setState(() {});
  }

  void handlePaddleCollision(Player player) {
    // Calculate the horizontal and vertical distances between the ball and the player's center
    double horizontalDistance = ball.centerX - player.centerX;
    double verticalDistance = ball.centerY - player.centerY;

    // Calculate the horizontal and vertical speed components
    double horizontalSpeed = horizontalDistance / playerRadius;
    double verticalSpeed = verticalDistance / playerRadius;

    // Adjust the speed factors (make the ball move faster or slower)
    double speedFactor = 2.0;

    // Limit the maximum speed
    double maxSpeed = 2.0;
    horizontalSpeed = horizontalSpeed.clamp(-maxSpeed, maxSpeed);
    verticalSpeed = verticalSpeed.clamp(-maxSpeed, maxSpeed);

    // Calculate the new x and y speeds based on the direction of collision
    if (horizontalDistance.abs() > verticalDistance.abs()) {
      // Horizontal collision
      xSpeed = horizontalSpeed * speedFactor;
      ySpeed = verticalSpeed / horizontalSpeed.abs();
      ySpeed *= speedFactor;
    } else {
      // Vertical collision
      xSpeed = horizontalSpeed / verticalSpeed.abs();
      xSpeed *= speedFactor;
      ySpeed = verticalSpeed * speedFactor;
    }

    // Check for player's shot and adjust the speed if needed
    if (player.shotX != 0) {
      xSpeed = player.shotX * speedFactor;
      ySpeed = player.shotY * speedFactor;
    }
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
      tableWidth = sWidth;
      tableHeight = sHeight - 100;
      player1.left = sWidth / 2 - playerRadius;
      player1.top = playerSize * 1.2;
      player2.left = sWidth / 2 - playerRadius;
      player2.top = sHeight - (playerSize * 3.5);
      textStartLeft = tableWidth / 2 - textStartWidth / 2;
      textStartTop = tableHeight / 2 - textStartHeight / 2;
      ball.left = sWidth / 2 - ballRadius;
      ball.top = (sHeight / 2) - ballRadius - 50;
      turn = math.Random().nextBool() ? player1.name : player2.name;
      gameIsStarted = true;
    } else {
      if (widget.gameMode == GameMode.ai) {
        defendGoal();
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
          color: Colors.white.withOpacity(.9),
          width: sWidth,
          height: sHeight - 100,
          child: Stack(
            children: [
              /**
               * The table which is stateless and does not move
               * This is the design of the board created by Tirioh, Abiodun and CCLeo
               */
              Positioned(
                child: Column(
                  children: [
                    const Expanded(child: TopSpace(playerSize: playerSize)),
                    Divider(color: Colors.blue[800], thickness: 4),
                    const SizedBox(height: playerSize * 2),
                    const CenterLine(),
                    const SizedBox(height: playerSize * 2),
                    Divider(color: Colors.blue[800], thickness: 4),
                    const Expanded(child: BottomSpace(playerSize: playerSize)),
                  ],
                ),
              ),

              // Goal Area Container with Borders
              Positioned(
                left: 0, // Align to the left edge of the table
                top: 0, // Align to the top edge of the table
                child: Container(
                  width: sWidth,
                  height: sHeight - 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 7,
                    ),
                  ),
                ),
              ),
              // Goalpost 1
              Positioned(
                left: (sWidth - goalWidth) / 2, // Centered
                top: 0, // Align to the top
                child: Container(
                  width: goalWidth,
                  height: 5,
                  color: Colors.red.shade800,
                ),
              ),
              // Goalpost 2
              Positioned(
                left: (sWidth - goalWidth) / 2, // Centered
                bottom: 0, // Align to the top
                child: Container(
                  width: goalWidth,
                  height: 5,
                  color: Colors.red.shade800, // Transparent background
                ),
              ),
              // player2 (bottom player)
              !gameIsFinished
                  ? Positioned(
                      left: player2.left,
                      top: player2.top,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          player2.left += details.delta.dx;
                          player2.left = player2.left > 0 ? player2.left : 0;
                          player2.left = player2.left < (tableWidth - playerSize) ? player2.left : (tableWidth - playerSize);
                          player2.shotX = details.delta.dx;
                          player2.top += details.delta.dy;
                          player2.top = player2.top > 0 ? player2.top : 0;
                          player2.top = player2.top > (sHeight / 2 - (kToolbarHeight - 20)) ? player2.top : (sHeight / 2 - (kToolbarHeight - 20));
                          player2.top = player2.top >= (sHeight - (kToolbarHeight + 100)) ? sHeight - (kToolbarHeight + 100) : player2.top;
                          player2.shotY = details.delta.dy;
                          setState(() {});
                        },
                        onPanEnd: (details) {
                          player2.shotX = 0;
                          player2.shotY = 0;
                          setState(() {});
                        },
                        child: PlayerChip(
                          player: player2,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),

              // player1 (top player)
              !gameIsFinished
                  ? Positioned(
                      left: player1.left,
                      top: player1.top,
                      child: Builder(builder: (context) {
                        if (widget.gameMode == GameMode.player2) {
                          return PlayerChip(
                            player: player1,
                          );
                        }
                        if (widget.gameMode == GameMode.multiplayer) {}
                        return PlayerChip(
                          player: player1,
                        );
                      }), // Player2 is now controlled by AI.
                    )
                  : const SizedBox.shrink(),
              // ball and score text
              Positioned(
                right: 24,
                top: (MediaQuery.of(context).size.height / 2) - 156,
                child: Column(
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        player1.score.toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 51),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4),
                        ),
                        child: Center(
                          child: Transform.rotate(
                            angle: math.pi / 2,
                            child: const Icon(
                              Icons.pause,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 51),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        player2.score.toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              !gameIsFinished
                  ? Positioned(
                      left: ball.left,
                      top: ball.top,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        width: ballSize,
                        height: ballSize,
                        decoration: BoxDecoration(
                          color: ball.color,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),

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
                          style: TextStyle(fontSize: textStartFontSize, color: turn == player1.name ? player1.color : player2.color),
                        ),
                      ),
                      onPressed: () async {
                        if (gameIsFinished) {
                          return;
                        }
                        xSpeed = math.Random().nextBool() ? (math.Random().nextInt(2) + 1).toDouble() : -(math.Random().nextInt(2) + 1).toDouble();
                        ySpeed = turn == player1.name ? (math.Random().nextInt(1) + 1).toDouble() : -(math.Random().nextInt(1) + 1).toDouble();
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
                            player1.left = sWidth / 2 - playerRadius;
                            player1.top = playerSize * 1.2;
                            player2.left = sWidth / 2 - playerRadius;
                            player2.top = sHeight - (playerSize * 3.5);
                            ball.left = sWidth / 2 - ballRadius;
                            ball.top = (sHeight / 2) - ballRadius - 50;
                            setState(() {});
                            nextRound(player1.name);
                            break;
                          } else if (ball.top <= 0 - ballSize * 2 / 3) {
                            player1.left = sWidth / 2 - playerRadius;
                            player1.top = playerSize * 1.2;
                            player2.left = sWidth / 2 - playerRadius;
                            player2.top = sHeight - (playerSize * 3.5);
                            ball.left = sWidth / 2 - ballRadius;
                            ball.top = (sHeight / 2) - ballRadius - 50;
                            nextRound(player2.name);
                            break;
                          }
                          doTheMathWork();
                          await Future.delayed(const Duration(milliseconds: 1));
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
    );
  }
}
