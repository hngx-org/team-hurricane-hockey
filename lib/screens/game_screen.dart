import 'dart:math' as math;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/constants.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/models/game.dart';
import 'package:team_hurricane_hockey/models/player.dart';
import 'package:team_hurricane_hockey/models/puck.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/home_menu.dart';
import 'package:team_hurricane_hockey/screens/provider/game_provider.dart';
import 'package:team_hurricane_hockey/screens/widgets/button.dart';
import 'package:team_hurricane_hockey/screens/widgets/center_circe.dart';
import 'package:team_hurricane_hockey/screens/widgets/player.dart';
import 'package:team_hurricane_hockey/screens/widgets/spaces.dart';
import 'package:team_hurricane_hockey/services/firebase/game_service.dart';
import 'package:team_hurricane_hockey/sound_control.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final String? gameId;
  final String? playerId;
  final String? opponentId;
  final double? speed;

  const GameScreen({
    Key? key,
    required this.gameMode,
    this.gameId,
    this.playerId,
    this.opponentId,
    this.speed,
  }) : super(key: key);
  static const routeName = 'gameScreen';

  @override
  State<GameScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GameScreen> {
  Game? game;
  final sound = SoundControl();
  final p = Provider.of<MyProvider>(BaseNavigator.currentContext);

  @override
  void initState() {
    super.initState();

    sound.initGoalSfx();
    sound.initPaddleSfx();
    sound.initWallSfx();
    sound.initFinalWhistle();

    final paddleColorProvider =
        Provider.of<PaddleColorProvider>(context, listen: false);
    if (widget.gameMode == GameMode.ai) {
      player1 = Player(
        name: "Computer",
        color: paddleColorProvider.player1Color,
      );

      player2 = Player(
        name: "Player",
        color: paddleColorProvider.player2Color,
      );
    } else if (widget.gameMode == GameMode.player2) {
      player1 = Player(
        name: "Player 1",
        color: paddleColorProvider.player1Color,
      );

      player2 = Player(
        name: "Player 2",
        color: paddleColorProvider.player2Color,
      );
    } else {
      player1 = Player(
        name: "Player 1",
        color: paddleColorProvider.player1Color,
      );

      player2 = Player(
        name: "Player 2",
        color: paddleColorProvider.player2Color,
      );
    }

    ball = Puck(
      name: paddleColorProvider.puckColor.toString(),
      color: paddleColorProvider.puckColor,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getGameDetails();
    });
  }

  getGameDetails() async {
    // final paddleColorProvider = Provider.of<PaddleColorProvider>(context, listen: false);

    if (widget.gameId == null) {
      return;
    }
    if (widget.gameMode == GameMode.multiplayer) {
      final serverGame = await GameService.instance.getGame(widget.gameId!);

      if (serverGame != null) {
        game = serverGame;
        // if (game?.players?.playerId1?.id == widget.playerId) {
        //   player2 = Player(
        //     name: game!.players!.playerId1!.name!,
        //     color: paddleColorProvider.player2Color,
        //   );

        //   player1 = Player(
        //     name: game!.players!.playerId2!.name!,
        //     color: paddleColorProvider.player1Color,
        //   );
        // } else {
        //   player2 = Player(
        //     name: game!.players!.playerId2!.name!,
        //     color: paddleColorProvider.player2Color,
        //   );

        //   player1 = Player(
        //     name: game!.players!.playerId1!.name!,
        //     color: paddleColorProvider.player1Color,
        //   );
        // }
      } else {
        game = Game(
          players: Players(),
        );
      }
    }
  }

  // player 1 & 2 and ball variables
  Player player1 = Player(
    name: "Computer",
    color: Colors.red,
  );
  Player player2 = Player(
    name: "Player 2",
    color: Colors.blue,
  );

  Puck ball = Puck(
    name: "ball",
    color: Colors.black,
  );

  // ball attributes
  late double xSpeed = 0;
  late double ySpeed = 0;

//for pausing game
  late double temporaryXSpeed;
  late double temporaryYSpeed;

  // last known grid positions
  double lastKnownX = 0;
  double lastKnownY = 0;

  double lastKnownOppX = 0;
  double lastKnownOppY = 0;

  final goalWidth = 160.0.w;

  gridSizingFunction({
    required double left,
    required double top,
    required double minY,
    required double maxY,
  }) async {
    final gridX =
        ((MediaQuery.of(context).size.width - 14.w) / 5).ceilToDouble();
    final gridY =
        ((MediaQuery.of(context).size.height - 14.w) / 11).ceilToDouble();
    /**
     * Get grid to send to DB 
     */
    final verticalGrid = (top / gridY).ceilToDouble();
    final horizontalGrid = (left / gridX).ceilToDouble();

    if (!(lastKnownX == horizontalGrid.toDouble() &&
        lastKnownY == verticalGrid.toDouble())) {
      if (widget.gameId != null && widget.gameMode == GameMode.multiplayer) {
        GameService.instance.updatePaddleMovement(
          widget.gameId!,
          widget.playerId!,
          horizontalGrid,
          verticalGrid,
        );
      }
    }
    lastKnownX = horizontalGrid.toDouble();
    lastKnownY = verticalGrid.toDouble();
    /**
     * On getting the grid, multiply the (phoneWidth -14.w / 5).toCeiling on X and (phoneHeight -14.w / 11).toCeiling on Y
     * On getting on other phone
     * 11 - verticalGrid
     * */
  }

  // table attributes
  late final double tableHeight;
  late final double tableWidth;

  // Start text attributes
  String textStart = 'Tap to start';
  final textStartHeight = 120.0.h;
  final textStartWidth = 480.0.w;
  double textStartFontSize = 30.0.sp;
  late final double textStartTop;
  late final double textStartLeft;

  movePlayer1(
    Player player,
    double dx,
    double dy,
  ) async {
    if (mounted) {
      player.left += dx;
      if (player.left <= 7.w) {
        player.left = 7.w;
      } else {
        player.left = player.left;
      }
      player.left = player.left < (tableWidth - (playerSize.w + 7.w))
          ? player.left
          : (tableWidth - (playerSize.w + 7.w));
      player.top += dy;
      if (player.top <= 7.w) {
        player.top = 7.w;
      } else {
        player.top = player.top;
      }

      if (player.top >
          MediaQuery.of(context).size.height / 2 - (playerSize.w + 7.w)) {
        player.top =
            MediaQuery.of(context).size.height / 2 - (playerSize.w + 7.w);
      } else {
        player.top = player.top;
      }
    }
  }

  movePlayer1Multiplayer(
    Player player,
    double dx,
    double dy,
  ) async {
    if (lastKnownOppX == dx && lastKnownOppY == dy) {
      return;
    }

    final gridX =
        ((MediaQuery.of(context).size.width - 14.w) / 5).ceilToDouble();
    final gridY =
        ((MediaQuery.of(context).size.height - 14.w) / 11).ceilToDouble();
    const xGrids = 5;
    const yGrids = 11;
    lastKnownOppX = dx;
    lastKnownOppY = dy;

    player.left = gridX * (xGrids - dx);
    player.left = player.left <= 7.w ? 7.w : player.left;
    player.left = player.left < (tableWidth - playerSize.w + 7.w)
        ? player.left
        : (tableWidth - playerSize.w + 7.w);

    player.top = (gridY * (yGrids - dy));
    player.top = player.top > 7.w ? player.top : 7.w;
    if (player.top == gridY) {
      player.top = 7.w;
    } else {
      player.top = player.top >
              (MediaQuery.of(context).size.height / 2 - (playerSize.w + 7.w))
          ? (MediaQuery.of(context).size.height / 2 - (playerSize.w + 7.w))
          : player1.top;
    }
  }

  movePlayer2(
    Player player,
    double dx,
    double dy,
  ) async {
    if (mounted) {
      player.left += dx;
      if (player.left <= 7.w) {
        player.left = 7.w;
      } else {
        player.left = player.left;
      }
      player.left = player.left < (tableWidth - (playerSize.w + 7.w))
          ? player.left
          : (tableWidth - (playerSize.w + 7.w));
      player.top += dy;
      if (player.top <= 7.w) {
        player.top = 7.w;
      } else {
        player.top = player.top;
      }
      if (player.top > MediaQuery.of(context).size.height / 2 &&
          player.top >=
              MediaQuery.of(context).size.height - (playerSize.w + 7.w)) {
        player.top = MediaQuery.of(context).size.height - (playerSize.w + 7.w);
      } else if (player.top > MediaQuery.of(context).size.height / 2) {
        player.top = player2.top;
      } else {
        player.top = MediaQuery.of(context).size.height / 2;
      }

      gridSizingFunction(
        left: player.left,
        top: player.top,
        minY: MediaQuery.of(context).size.height / 2,
        maxY: MediaQuery.of(context).size.height - (playerSize.h + 7.w),
      );
    }
  }

  // global attributes
  final gameProvider = GameProvider.instance;
  late String turn;
  bool gameIsStarted = false;
  bool gameIsFinished = false;
  bool showStartText = true;
  late double distanceBall2P1;
  late double distanceBall2P2;
  int gameEndsAt = 7;
  Offset? previousPoint;

  Future<void>? nextRound(String player) {
    player == player1.name ? player1.score++ : player2.score++;
    turn = player;
    xSpeed = 0;
    ySpeed = 0;
    showStartText = true;

    if ((widget.gameMode == GameMode.ai && player1.score == p.gameEndsAt) ||
        (widget.gameMode == GameMode.player2 && player1.score == gameEndsAt)||
        (widget.gameMode == GameMode.multiplayer && player1.score == gameEndsAt)) {
      blowFinalWhistle();
      turn = player1.name;
      gameIsFinished = true;
      return showDialog(
          context: BaseNavigator.currentContext,
          builder: (context) {
            return gameCompleteDialog(
                gameCompleteDialogTitle: "${player1.name} Wins");
          });

      // textStartFontSize *= 2;
    } else if ((widget.gameMode == GameMode.ai &&
            player2.score == p.gameEndsAt) ||
        (widget.gameMode == GameMode.player2 && player2.score == gameEndsAt)||
        (widget.gameMode == GameMode.multiplayer && player2.score == gameEndsAt)) {
      blowFinalWhistle();
      gameIsFinished = true;
      return showDialog(
          context: BaseNavigator.currentContext,
          barrierColor: Colors.black.withOpacity(0.8),
          builder: (context) {
            return gameCompleteDialog(
                gameCompleteDialogTitle: "${player2.name} Wins");
          });

      // turn = player2.name;
    }
    ball.left = (MediaQuery.of(context).size.width / 2) - ballRadius;
    ball.top = (MediaQuery.of(context).size.height / 2) - ballRadius;
    return null;
  }

  AlertDialog gameCompleteDialog({required String gameCompleteDialogTitle}) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      title: Center(
        child: Text(
          gameCompleteDialogTitle,
        ),
      ),
      titleTextStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
            color: Colors.blue,
          ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () async {
                sound.playSfx();
                player1.score = 0;
                player2.score = 0;

                player1.left = tableWidth / 2 - playerRadius;
                player1.top = playerSize * 1.2;
                player2.left = tableWidth / 2 - playerRadius;
                player2.top = tableHeight - (playerSize * 2.5);
                // textStartLeft = tableWidth / 2 - textStartWidth / 2;
                // textStartTop = tableHeight / 2 - textStartHeight / 2;
                ball.left = tableWidth / 2 - ballRadius;
                ball.top = tableHeight / 2 - ballRadius;
                turn = math.Random().nextBool() ? player1.name : player2.name;
                gameIsStarted = true;
                gameIsFinished = false;
                setState(() {});
                Navigator.pop(context);
              },
              label: Text(
                'PLAY AGAIN',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontSize: 18.sp),
              ),
              icon: const Icon(
                Icons.refresh_sharp,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15.0),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {
                sound.playSfx();
                BaseNavigator.pushNamedAndclear(HomeMenu.routeName);
              },
              label: Text(
                'BACK TO MENU',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontSize: 18.sp),
              ),
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            // const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  double pythagoras(double a, double b) {
    return math.sqrt(math.pow(a, 2).toDouble() + math.pow(b, 2).toDouble());
  }

  void playWallSound() {
    sound.onWallCollision;
  }

  void playPaddleSound() {
    sound.onPaddleCollision();
  }

  void playGoalSound() {
    sound.onGoal();
  }

  void blowFinalWhistle() {
    sound.onGameFinished();
  }

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
        ((ball.centerX >= goalLeft1 && ball.centerX <= goalRight1) ||
            (ball.centerX >= goalLeft2 && ball.centerX <= goalRight2))) {
      playGoalSound();
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

  void updateAI() {
    //print(ball.centerX);
    if ((ball.centerX - player1.centerX) < playerSize &&
        tableWidth - ball.centerX < 40) {
      player1.left -= Random().nextDouble() * 20;
      player1.top -= Random().nextDouble() * 20;
    } else if ((ball.centerX - player1.centerX) < playerSize &&
        ball.centerX < 40) {
      player1.left += Random().nextDouble() * 20;
      player1.top -= Random().nextDouble() * 20;
    } else {
      if (ball.bottom < tableHeight / 2) {
        if (ball.centerX > player1.centerX) {
          // Move the paddle right to follow the puck

          player1.left += widget.speed ?? 2.0;
        } else if (ball.centerX < player1.centerX) {
          // Move the paddle left to follow the puck

          player1.left -= widget.speed ?? 2.0;
        }

        // Check if the ball is in the AI's half

        // If the puck is in the AI's half, adjust the paddle's vertical position
        if (ball.centerY > player1.centerY) {
          // Move the paddle down to follow the puck
          player1.top += widget.speed ?? 2.0;
        } else if (ball.centerY < player1.centerY) {
          // Move the paddle up to follow the puck
          player1.top -= widget.speed ?? 2.0;
        }
      } else {
        if (player1.top >= playerSize * 1.2) {
          player1.top -= widget.speed ?? 2.0;
        }
        if (player1.left >= tableWidth / 2 - playerRadius) {
          player1.left -= widget.speed ?? 2.0;
        } else {
          player1.left += widget.speed ?? 2.0;
        }
      }
    }

    // Limit the paddle's movement within the game boundaries
    player1.left =
        max(min(player1.left, tableWidth - (playerSize + ballSize)), 0);
    player1.top = max(
        min(player1.top, (tableHeight / 2) - 100), (playerRadius + ballSize));
  }

  void handlePaddleCollision(Player player) {
    playPaddleSound();
    // Calculate the horizontal and vertical distances between the ball and the player's center
    double horizontalDistance = ball.centerX - player.centerX;
    double verticalDistance = ball.centerY - player.centerY;

    // Calculate the horizontal and vertical speed components
    double horizontalSpeed = horizontalDistance / playerRadius;
    double verticalSpeed = verticalDistance / playerRadius;

    // Adjust the speed factors (make the ball move faster or slower)
    double speedFactor = 2.0;
    // Limit the maximum speed
    double maxSpeed = 3.0;
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
      xSpeed = (player.shotX) / speedFactor;
    }
    if (player.shotY != 0) {
      ySpeed = (player.shotY) / speedFactor;
    }
  }

  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    double sWidth = MediaQuery.of(context).size.width;
    double sHeight = MediaQuery.of(context).size.height;

    if (!gameIsStarted) {
      player1.score = 0;
      player2.score = 0;
      tableWidth = sWidth;
      tableHeight = sHeight;
      player1.left = sWidth / 2 - playerRadius;
      player1.top = playerSize * 1.2;
      player2.left = sWidth / 2 - playerRadius;
      player2.top = sHeight - (playerSize * 2.5);
      textStartLeft = tableWidth / 2 - textStartWidth / 2;
      textStartTop = tableHeight / 2 - textStartHeight / 2;
      ball.left = sWidth / 2 - ballRadius;
      ball.top = sHeight / 2 - ballRadius;
      turn = math.Random().nextBool() ? player1.name : player2.name;
      gameIsStarted = true;
    } else {
      if (widget.gameMode == GameMode.ai && !isPaused) {
        updateAI();
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
          color: Colors.white.withOpacity(.9),
          width: sWidth,
          height: sHeight,
          child: Stack(
            children: [
              /**
               * The table which is stateless and does not move
               * This is the design of the board created by Tirioh, Abiodun and CCLeo
               */
              Positioned(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: TopSpace(playerSize: playerSize.w)),
                    Divider(color: Colors.blue[800], thickness: 3.w),
                    SizedBox(height: playerSize.h),
                    const CenterLine(),
                    SizedBox(height: playerSize.h),
                    Divider(color: Colors.blue[800], thickness: 3.w),
                    Expanded(child: BottomSpace(playerSize: playerSize.w)),
                  ],
                ),
              ),

              // Goal Area Container with Borders
              Positioned(
                left: 0, // Align to the left edge of the table
                top: 0, // Align to the top edge of the table
                child: Container(
                  width: sWidth,
                  height: sHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue.shade900,
                      width: 7.w,
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
                  height: 7.w,
                  color: Colors.red.shade800,
                ),
              ),
              // Goalpost 2
              Positioned(
                left: (sWidth - goalWidth) / 2, // Centered
                bottom: 0, // Align to the top
                child: Container(
                  width: goalWidth,
                  height: 7.w,
                  color: Colors.red.shade800, // Transparent background
                ),
              ),
              // player2 (bottom player)
              !gameIsFinished
                  ? AnimatedPositioned(
                      duration: const Duration(milliseconds: 80),
                      left: player2.left,
                      top: player2.top,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          movePlayer2(
                            player2,
                            details.delta.dx,
                            details.delta.dy,
                          );
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
                  ? AnimatedPositioned(
                      duration: const Duration(milliseconds: 100),
                      left: player1.left,
                      top: player1.top,
                      child: Builder(
                        builder: (context) {
                          if (widget.gameMode == GameMode.player2) {
                            return GestureDetector(
                              onPanUpdate: (details) {
                                movePlayer1(
                                  player1,
                                  details.delta.dx,
                                  details.delta.dy,
                                );
                                setState(() {});
                              },
                              onPanEnd: (details) {
                                player1.shotX = 0;
                                player1.shotY = 0;
                                setState(() {});
                              },
                              child: PlayerChip(
                                player: player1,
                              ),
                            );
                          }
                          if (widget.gameMode == GameMode.multiplayer) {
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("playing")
                                  .doc(widget.gameId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final game =
                                      Game.fromJson(snapshot.data!.data()!);
                                  if (game.players?.playerId1?.id ==
                                      widget.playerId) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((t) {
                                      movePlayer1Multiplayer(
                                        player1,
                                        game.player2Position!.x!.toDouble(),
                                        game.player2Position!.y!.toDouble(),
                                      );
                                      setState(() {});
                                    });
                                  } else if (game.players?.playerId2?.id ==
                                      widget.playerId) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((t) {
                                      movePlayer1Multiplayer(
                                        player1,
                                        game.player1Position!.x!.toDouble(),
                                        game.player1Position!.y!.toDouble(),
                                      );
                                      setState(() {});
                                    });
                                  }
                                }

                                return PlayerChip(
                                  player: player1,
                                );
                              },
                            );
                          }
                          return PlayerChip(
                            player: player1,
                          );
                        },
                      ), // Player2 is now controlled by AI.
                    )
                  : const SizedBox.shrink(),
              // ball and score text
              Positioned(
                top: (sHeight / 2 - 14.w) - (playerSize.w),
                right: 24.w,
                child: Column(
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        player1.score.toString(),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 51.h),
                    Visibility(
                      visible: (xSpeed != 0 && ySpeed != 0),
                      maintainAnimation: true,
                      maintainSize: true,
                      maintainState: true,
                      child: InkWell(
                        onTap: () {
                          sound.playSfx();
                          temporaryXSpeed = xSpeed;
                          temporaryYSpeed = ySpeed;
                          setState(() {
                            xSpeed = 0;
                            ySpeed = 0;
                            isPaused = true;
                          });
                        },
                        child: Container(
                          height: 48.h,
                          width: 48.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4.w),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: math.pi / 2,
                              child: Icon(
                                Icons.pause,
                                size: 30.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 51.h),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        player2.score.toString(),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              !gameIsFinished
                  ? AnimatedPositioned(
                      duration: const Duration(milliseconds: 15),
                      left: ball.left,
                      top: ball.top,
                      child: Container(
                        padding: const EdgeInsets.all(7.0),
                        width: ballSize,
                        height: ballSize,
                        decoration: BoxDecoration(
                          color: ball.color,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: ballSize,
                          height: ballSize,
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
                      style: Theme.of(context).textButtonTheme.style?.copyWith(
                            backgroundColor: const MaterialStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                      child: RotatedBox(
                        quarterTurns: turn == player1.name ? 2 : 0,
                        child: Text(
                          textStart,
                          style: TextStyle(
                            fontSize: textStartFontSize,
                            color: turn == player1.name
                                ? player1.color
                                : player2.color,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (gameIsFinished) {
                          return;
                        }
                        xSpeed = math.Random().nextBool() ? 1.2 : -1.2;
                        ySpeed = turn == player1.name ? 1.2 : -1.2;
                        showStartText = false;
                        while (mounted) {
                          ball.left += xSpeed;
                          ball.top += ySpeed;

                          if (ball.left == 7.w ||
                              ball.left >= tableWidth - ballSize) {
                            playWallSound();
                          }

                          if (ball.top == 7.w ||
                              ball.top == tableHeight - 14.w) {
                            playWallSound();
                          }

                          if (ball.left > tableWidth - ballSize) {
                            xSpeed = (-1) * (xSpeed.abs());
                          } else if (ball.left <= 0) {
                            xSpeed = xSpeed.abs();
                          }
                          if (ball.top > tableHeight - ballSize / 3) {
                            player1.left = sWidth / 2 - playerRadius;
                            player1.top = playerSize * 1.2;
                            player2.left = sWidth / 2 - playerRadius;
                            player2.top = sHeight - (playerSize * 2.5);
                            ball.left = sWidth / 2 - ballRadius;
                            ball.top = (sHeight / 2) - ballRadius - 50;
                            setState(() {});
                            nextRound(player1.name);
                            break;
                          } else if (ball.top <= 0 - ballSize * 2 / 3) {
                            player1.left = sWidth / 2 - playerRadius;
                            player1.top = playerSize * 1.2;
                            player2.left = sWidth / 2 - playerRadius;
                            player2.top = sHeight - (playerSize * 2.5);
                            ball.left = sWidth / 2 - ballRadius;
                            ball.top = (sHeight / 2) - ballRadius - 50;
                            nextRound(player2.name);
                            break;
                          }
                          // if (ball.left == 0 ||
                          //     ball.right == tableWidth ||
                          //     ball.top == 0 ||
                          //     ball.bottom == tableHeight) {
                          //   playWallSound();
                          // }
                          doTheMathWork();
                          await Future.delayed(const Duration(milliseconds: 1));
                          if (mounted) {
                            setState(() {});
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isPaused,
                child: Stack(
                  children: [
                    Container(
                      height: sHeight,
                      width: sWidth,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    AlertDialog(
                      backgroundColor: Colors.transparent,
                      title: const Center(
                        child: Text(
                          "PAUSED",
                        ),
                      ),
                      titleTextStyle: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Button(
                            child: Text("RESUME",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontSize: 18.sp)),
                            onTap: () {
                              setState(() {
                                sound.playSfx();
                                xSpeed = temporaryXSpeed;
                                ySpeed = temporaryYSpeed;
                                isPaused = false;
                              });
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Button(
                            child: Text(
                              "QUIT",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontSize: 18.sp),
                            ),
                            onTap: () {
                              sound.playSfx();
                              BaseNavigator.pop();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
