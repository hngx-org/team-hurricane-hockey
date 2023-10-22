// ignore_for_file: prefer_conditional_assignment, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/constants.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/models/game.dart';
import 'package:team_hurricane_hockey/models/player.dart';
import 'package:team_hurricane_hockey/models/puck.dart';
import 'package:team_hurricane_hockey/models/server/game_event.dart' as m_event;
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/home/home_menu.dart';
import 'package:team_hurricane_hockey/screens/provider/game_provider.dart';
import 'package:team_hurricane_hockey/screens/widgets/button.dart';
import 'package:team_hurricane_hockey/screens/widgets/center_circe.dart';
import 'package:team_hurricane_hockey/screens/widgets/player.dart';
import 'package:team_hurricane_hockey/screens/widgets/spaces.dart';
import 'package:team_hurricane_hockey/services/firebase/game_service.dart';
import 'package:team_hurricane_hockey/services/web_socket_service.dart/socket_service.dart';
import 'package:team_hurricane_hockey/sound_control.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final String? gameId;
  final String? playerId;
  final String? opponentId;
  final double? speed;
  final bool? isPlayer2;

  const GameScreen({
    Key? key,
    required this.gameMode,
    this.gameId,
    this.playerId,
    this.opponentId,
    this.speed,
    this.isPlayer2,
  }) : super(key: key);
  static const routeName = 'gameScreen';

  @override
  State<GameScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GameScreen> {
  Game? game;
  final sound = SoundControl();
  final p = Provider.of<MyProvider>(BaseNavigator.currentContext);
  m_event.GameEvent? event;
  @override
  void dispose() {
    if (widget.gameMode == GameMode.multiplayer) {
      SocketService.instance.closeConnection();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    sound.initGoalSfx();
    sound.initPaddleSfx();
    sound.initWallSfx();
    sound.initFinalWhistle();

    final paddleColorProvider = Provider.of<PaddleColorProvider>(context, listen: false);
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
      if (widget.isPlayer2 == true) {
        player1 = Player(
          name: widget.opponentId!,
          color: paddleColorProvider.player1Color,
        );

        player2 = Player(
          name: widget.playerId!,
          color: paddleColorProvider.player2Color,
        );
      } else {
        player1 = Player(
          name: widget.opponentId!,
          color: paddleColorProvider.player1Color,
        );

        player2 = Player(
          name: widget.playerId!,
          color: paddleColorProvider.player2Color,
        );
      }
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
    try {
      if (widget.gameId == null) {
        return;
      }
      if (widget.gameMode == GameMode.multiplayer) {
        final serverGame = await GameService.instance.getGame(widget.gameId!);

        if (serverGame != null) {
          game = serverGame;
        } else {
          game = Game(
            players: Players(),
          );
        }

        await SocketService.instance.initSocketConnection(widget.gameId!);
        SocketService.instance.connectAndListen(
          // On data received from the socket connection
          (data) async {
            final decoded = jsonDecode(data);
            final ev = m_event.GameEvent.fromJson(decoded["data"]);
            event = ev;
            receivingData(ev);
            receivingBallData(ev);
          },
          // On error received from the socket connection
          (error) async {
            print("error: $error");
          },
          // On error received from the socket connection when it is cancelled
          () async {
            print("socket closed");
          },
        );
      }
    } catch (e) {
      print(e);
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

  double player1MutiplayerScore = 0;
  double player2MutiplayerScore = 0;

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

  double lastKnownBallX = 0;
  double lastKnownBallY = 0;

  double lastKnownOppX = 0;
  double lastKnownOppY = 0;

  final goalWidth = 160.0.w;

  double accumulatedX = 0.0;
  double accumulatedY = 0.0;

  double accumulatedBallMovementX = 0.0;
  double accumulatedBallMovementY = 0.0;

  Timer? sendTimer;
  Timer? ballTimer;

  Future transferBallMovement({
    required double dx,
    required double dy,
  }) async {
    if (!(lastKnownBallX == dy.toDouble() && lastKnownBallY == dy.toDouble())) {
      if (widget.gameId != null && widget.gameMode == GameMode.multiplayer) {
        if (game?.players?.playerId1?.id == widget.playerId) {
          //If I'm player 1 from the firebase db
          m_event.GameEvent event = m_event.GameEvent(
            events: m_event.Events(
              ballPosition: m_event.Position(
                x: dx.toInt(),
                y: dy.toInt(),
              ),
              player1Position: m_event.Position(
                x: lastKnownX.toInt(),
                y: lastKnownY.toInt(),
              ),
              player2Position: m_event.Position(
                x: lastKnownOppX.toInt(),
                y: lastKnownOppY.toInt(),
              ),
              gameStatus: "playing",
              player1: m_event.Player(
                id: 1,
                name: game?.players?.playerId1?.id,
                score: player1MutiplayerScore.toInt(),
              ),
              player2: m_event.Player(
                id: 2,
                name: game?.players?.playerId2?.id,
                score: player2MutiplayerScore.toInt(),
              ),
              gameRule: 10,
            ),
          );
          await SocketService.instance.sendData(event);
        } else {
          //If I'm player 2 from the firebase db
          m_event.GameEvent event = m_event.GameEvent(
            events: m_event.Events(
              ballPosition: m_event.Position(
                x: dx.toInt(),
                y: dy.toInt(),
              ),
              player1Position: m_event.Position(
                x: lastKnownOppX.toInt(),
                y: lastKnownOppY.toInt(),
              ),
              player2Position: m_event.Position(
                x: lastKnownX.toInt(),
                y: lastKnownY.toInt(),
              ),
              gameStatus: "playing",
              player1: m_event.Player(
                id: 1,
                name: game?.players?.playerId1?.id,
                score: player1MutiplayerScore.toInt(),
              ),
              player2: m_event.Player(
                id: 2,
                name: game?.players?.playerId2?.id,
                score: player2MutiplayerScore.toInt(),
              ),
              gameRule: 10,
            ),
          );
          await SocketService.instance.sendData(event);
        }
      }
    }
    lastKnownBallX = dx.toDouble();
    lastKnownBallY = dy.toDouble();
  }

  transfer({
    required double dx,
    required double dy,
  }) async {
    if (!(lastKnownX == dy.toDouble() && lastKnownY == dy.toDouble())) {
      if (widget.gameId != null && widget.gameMode == GameMode.multiplayer) {
        if (game?.players?.playerId1?.id == widget.playerId) {
          //If I'm player 1 from the firebase db
          m_event.GameEvent event = m_event.GameEvent(
            events: m_event.Events(
              ballPosition: m_event.Position(
                x: lastKnownBallX.toInt(),
                y: lastKnownBallY.toInt(),
              ),
              player1Position: m_event.Position(
                x: dx.toInt(),
                y: dy.toInt(),
              ),
              player2Position: m_event.Position(
                x: lastKnownOppX.toInt(),
                y: lastKnownOppY.toInt(),
              ),
              gameStatus: showStartText == true ? "Waiting" : "playing",
              player1: m_event.Player(
                id: 1,
                name: game?.players?.playerId1?.id,
                score: player1MutiplayerScore.toInt(),
              ),
              player2: m_event.Player(
                id: 2,
                name: game?.players?.playerId2?.id,
                score: player2MutiplayerScore.toInt(),
              ),
              gameRule: 10,
            ),
          );
          SocketService.instance.sendData(event);
        } else {
          //If I'm player 2 from the firebase db
          m_event.GameEvent event = m_event.GameEvent(
            events: m_event.Events(
              ballPosition: m_event.Position(
                x: lastKnownBallX.toInt(),
                y: lastKnownBallY.toInt(),
              ),
              player1Position: m_event.Position(
                x: lastKnownOppX.toInt(),
                y: lastKnownOppY.toInt(),
              ),
              player2Position: m_event.Position(
                x: dx.toInt(),
                y: dy.toInt(),
              ),
              gameStatus: showStartText == true ? "Waiting" : "playing",
              player1: m_event.Player(
                id: 1,
                name: game?.players?.playerId1?.id,
                score: player1MutiplayerScore.toInt(),
              ),
              player2: m_event.Player(
                id: 2,
                name: game?.players?.playerId2?.id,
                score: player2MutiplayerScore.toInt(),
              ),
              gameRule: 10,
            ),
          );
          SocketService.instance.sendData(event);
        }
      }
    }
    lastKnownX = dx.toDouble();
    lastKnownY = dy.toDouble();
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
      player.left = player.left < (tableWidth - (playerSize.w + 7.w)) ? player.left : (tableWidth - (playerSize.w + 7.w));
      player.top += dy;
      if (player.top <= 7.w) {
        player.top = 7.w;
      } else {
        player.top = player.top;
      }

      if (player.top > tableHeight / 2 - (playerSize.w + 7.w)) {
        player.top = tableHeight / 2 - (playerSize.w + 7.w);
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
    if (mounted) {
      player.left += dx;
      if (player.left <= 7.w) {
        player.left = 7.w;
      } else {
        player.left = player.left;
      }
      player.left = player.left < (tableWidth - (playerSize.w + 7.w)) ? player.left : (tableWidth - (playerSize.w + 7.w));
      player.top += dy;
      if (player.top <= 7.w) {
        player.top = 7.w;
      } else {
        player.top = player.top;
      }

      if (player.top > tableHeight / 2 - (playerSize.w + 7.w)) {
        player.top = tableHeight / 2 - (playerSize.w + 7.w);
      } else {
        player.top = player.top;
      }
    }
  }

  moveMeMp(
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
      player.left = player.left < (tableWidth - (playerSize.w + 7.w)) ? player.left : (tableWidth - (playerSize.w + 7.w));
      player.top += dy;
      if (player.top <= 7.w) {
        player.top = 7.w;
      } else {
        player.top = player.top;
      }
      if (player.top > tableHeight / 2 && player.top >= tableHeight - (playerSize.w + 7.w)) {
        player.top = tableHeight - (playerSize.w + 7.w);
      } else if (player.top > tableHeight / 2) {
        player.top = player2.top;
      } else {
        player.top = tableHeight / 2;
      }
    }
  }

  moveBallMultiplayer(
    double dx,
    double dy,
  ) async {
    if (mounted) {
      accumulatedBallMovementX += dx;
      accumulatedBallMovementY += dy;

      if (ballTimer == null) {
        ballTimer = Timer(
          const Duration(milliseconds: 100),
          () async {
            await transferBallMovement(
              dx: accumulatedBallMovementX,
              dy: accumulatedBallMovementY,
            ).then((value) async {
              ball.left += accumulatedBallMovementX;
              ball.top += accumulatedBallMovementY;
            });

            accumulatedBallMovementX = 0.0;
            accumulatedBallMovementY = 0.0;
            ballTimer = null;
          },
        );
      }
    }
  }

  movePlayer2Multiplayer(
    Player player,
    double dx,
    double dy,
  ) async {
    if (mounted) {
      accumulatedX += dx;
      accumulatedY += dy;
      if (sendTimer == null) {
        sendTimer = Timer(
          const Duration(milliseconds: 250),
          () async {
            await transfer(
              dx: accumulatedX,
              dy: accumulatedY,
            );
            accumulatedX = 0.0;
            accumulatedY = 0.0;
            sendTimer = null;
          },
        );
      }
    }
  }

  moveBall(
    Puck ball,
    double dx,
    double dy,
  ) async {
    if (mounted) {
      if (turn != widget.playerId) {
        ball.left += dx;
        ball.top += dy;
      }
    }
  }

  receivingBallData(m_event.GameEvent event) async {
    if (event.events?.gameStatus == "playing") {
      showStartText = false;
      setState(() {});
    }

    if (turn != widget.playerId) {
      moveBall(
        ball,
        -event.events!.ballPosition!.x!.toDouble().w,
        -event.events!.ballPosition!.y!.toDouble().h,
      );
    } else {
      ball.left += event.events!.ballPosition!.x!.toDouble().w;
      ball.top += event.events!.ballPosition!.y!.toDouble().h;
    }

    setState(() {});
  }

  receivingData(m_event.GameEvent event) async {
    if (event.events?.player1?.name == widget.playerId) {
      /// I'm player 1 on server so move player 2 on my device
      moveMeMp(
        player2,
        event.events!.player1Position!.x!.toDouble().w,
        event.events!.player1Position!.y!.toDouble().h,
      );

      /// opponent is player 2 on server so I move player 1 on my device
      movePlayer1Multiplayer(
        player1,
        -event.events!.player2Position!.x!.toDouble().w,
        -event.events!.player2Position!.y!.toDouble().h,
      );
    } else {
      /// I'm player 2 on server so move player 2 on my device
      moveMeMp(
        player2,
        event.events!.player2Position!.x!.toDouble().w,
        event.events!.player2Position!.y!.toDouble().h,
      );

      /// opponent is player 1 on server so I move player 1 on my device
      movePlayer1Multiplayer(
        player1,
        -event.events!.player1Position!.x!.toDouble().w,
        -event.events!.player1Position!.y!.toDouble().h,
      );
    }
    setState(() {});
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
      player.left = player.left < (tableWidth - (playerSize.w + 7.w)) ? player.left : (tableWidth - (playerSize.w + 7.w));
      player.top += dy;
      if (player.top <= 7.w) {
        player.top = 7.w;
      } else {
        player.top = player.top;
      }
      if (player.top > tableHeight / 2 && player.top >= tableHeight - (playerSize.w + 7.w)) {
        player.top = tableHeight - (playerSize.w + 7.w);
      } else if (player.top > tableHeight / 2) {
        player.top = player2.top;
      } else {
        player.top = tableHeight / 2;
      }
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

    if (((widget.gameMode == GameMode.ai || widget.gameMode == GameMode.player2) && player1.score == p.gameEndsAt) ||
        (widget.gameMode == GameMode.multiplayer && player1.score == gameEndsAt)) {
      blowFinalWhistle();
      turn = player1.name;
      gameIsFinished = true;
      return showDialog(
          context: BaseNavigator.currentContext,
          barrierColor: Colors.black.withOpacity(0.8),
          builder: (context) {
            return gameCompleteDialog(gameCompleteDialogTitle: "${player1.name} Wins");
          });

      // textStartFontSize *= 2;
    } else if (((widget.gameMode == GameMode.ai || widget.gameMode == GameMode.player2) && player2.score == p.gameEndsAt) ||
        (widget.gameMode == GameMode.multiplayer && player2.score == gameEndsAt)) {
      blowFinalWhistle();
      gameIsFinished = true;
      return showDialog(
          context: BaseNavigator.currentContext,
          barrierColor: Colors.black.withOpacity(0.8),
          builder: (context) {
            return gameCompleteDialog(gameCompleteDialogTitle: "${player2.name} Wins");
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
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                elevation: 0,
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
                style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18.sp),
              ),
              icon: const Icon(
                Icons.refresh_sharp,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15.0),
            TextButton.icon(
              style: TextButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18.sp),
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
    sound.onWallCollision();
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

  void doTheMathWorkMultiplayer() async {
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
    if (ball.top <= -20 || ball.bottom >= tableHeight + 20) {
      playGoalSound(); // Play a sound when the ball passes the left goalpost
    }

    // Check if the ball has crossed the right goalpost
    // if (ball.left <= goalRight1 &&
    //     ball.right >= goalRight1 &&
    //     (ball.top <= player1.top || ball.bottom >= player1.bottom)) {
    //   playGoalSound(); // Play a sound when the ball passes the right goalpost
    // }
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
    double goalLeft1 = (tableWidth - goalWidth) / 2;
    double goalRight1 = goalLeft1 + goalWidth;
    double goalLeft2 = tableWidth / 2 - goalWidth / 2;
    double goalRight2 = goalLeft2 + goalWidth;
    //print(ball.top);
    if (ball.top <= -20 || ball.bottom >= tableHeight + 20) {
      playGoalSound(); // Play a sound when the ball passes the left goalpost
    }

    // Check if the ball has crossed the right goalpost
    // if (ball.left <= goalRight1 &&
    //     ball.right >= goalRight1 &&
    //     (ball.top <= player1.top || ball.bottom >= player1.bottom)) {
    //   playGoalSound(); // Play a sound when the ball passes the right goalpost
    // }
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

  void updateAI() {
    if ((ball.centerX - player1.centerX) < playerSize && tableWidth - ball.centerX < 40) {
      player1.left -= Random().nextDouble() * 20;
      player1.top -= Random().nextDouble() * 20;
    } else if ((ball.centerX - player1.centerX) < playerSize && ball.centerX < 40) {
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
    player1.left = max(min(player1.left, tableWidth - (playerSize + ballSize)), 0);
    player1.top = max(min(player1.top, (tableHeight / 2) - 100), (playerRadius + ballSize));
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
      tableWidth = sWidth - 14.w;
      tableHeight = sHeight - 14.w;
      player1.left = sWidth / 2 - playerRadius;
      player1.top = playerSize * 1.2;
      player2.left = sWidth / 2 - playerRadius;
      player2.top = sHeight - (playerSize * 2.5);
      textStartLeft = tableWidth / 2 - textStartWidth / 2;
      textStartTop = tableHeight / 2 - textStartHeight / 2;
      ball.left = sWidth / 2 - ballRadius;
      ball.top = sHeight / 2 - ballRadius;
      if (widget.gameMode == GameMode.multiplayer) {
        if (event == null) {
          if (widget.isPlayer2 == true) {
            turn = player1.name;
          } else {
            turn = player2.name;
          }
        } else {}
      } else {
        turn = math.Random().nextBool() ? player1.name : player2.name;
      }
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
                      duration: Duration(milliseconds: widget.gameMode == GameMode.multiplayer ? 200 : 80),
                      left: player2.left,
                      top: player2.top,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          if (widget.gameMode == GameMode.multiplayer) {
                            movePlayer2Multiplayer(
                              player2,
                              details.delta.dx.h,
                              details.delta.dy.w,
                            );
                          } else {
                            movePlayer2(
                              player2,
                              details.delta.dx,
                              details.delta.dy,
                            );
                          }

                          setState(() {});
                        },
                        onPanEnd: (details) {
                          player2.shotX = 0;
                          player2.shotY = 0;
                          setState(() {});
                        },
                        child: Builder(builder: (context) {
                          return PlayerChip(
                            player: player2,
                          );
                        }),
                      ),
                    )
                  : const SizedBox.shrink(),

              // player1 (top player)
              !gameIsFinished
                  ? AnimatedPositioned(
                      duration: Duration(milliseconds: widget.gameMode == GameMode.multiplayer ? 200 : 100),
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
                      duration: Duration(
                          milliseconds: widget.gameMode == GameMode.multiplayer
                              ? turn != widget.playerId
                                  ? 30
                                  : 80
                              : 30),
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
                            color: turn == player1.name ? player1.color : player2.color,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (gameIsFinished) {
                          return;
                        }

                        if (widget.gameMode == GameMode.multiplayer) {
                          if (turn != widget.playerId) {
                            return;
                          }
                          xSpeed = math.Random().nextBool() ? 1.2 : -1.2;
                          ySpeed = turn == widget.opponentId ? 1.2 : -1.2;

                          while (mounted) {
                            if (turn == widget.playerId) {
                              await moveBallMultiplayer(
                                xSpeed,
                                ySpeed,
                              );

                              if (ball.left <= 0 || ball.right >= tableWidth || ball.top <= 0 || ball.bottom >= tableHeight) {
                                // Check if the ball is rolling through the top or bottom

                                bool isRollingThroughTop = ball.top <= 0 && ySpeed < 0;
                                bool isRollingThroughBottom = ball.bottom >= tableHeight && ySpeed > 0;

                                if (isRollingThroughTop || isRollingThroughBottom) {
                                } else {
                                  playWallSound(); // Play a sound when the ball hits the border
                                }
                              }

                              if (ball.left > (tableWidth - ballSize)) {
                                xSpeed = (-1) * (xSpeed.abs());
                              } else if (ball.left <= 7.w) {
                                xSpeed = (xSpeed.abs());
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

                              doTheMathWork();
                              await Future.delayed(const Duration(milliseconds: 1));
                              if (mounted) {
                                setState(() {});
                              }
                            }
                          }
                        } else {
                          xSpeed = math.Random().nextBool() ? 1.2 : -1.2;
                          ySpeed = turn == player1.name ? 1.2 : -1.2;
                          showStartText = false;
                          while (mounted) {
                            ball.left += xSpeed;
                            ball.top += ySpeed;

                            if (ball.left <= 0 || ball.right >= tableWidth || ball.top <= 0 || ball.bottom >= tableHeight) {
                              // Check if the ball is rolling through the top or bottom

                              bool isRollingThroughTop = ball.top <= 0 && ySpeed < 0;
                              bool isRollingThroughBottom = ball.bottom >= tableHeight && ySpeed > 0;

                              if (isRollingThroughTop || isRollingThroughBottom) {
                              } else {
                                playWallSound(); // Play a sound when the ball hits the border
                              }
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

                            doTheMathWork();
                            await Future.delayed(const Duration(milliseconds: 1));
                            if (mounted) {
                              setState(() {});
                            }
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
                      titleTextStyle: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 36.sp, fontWeight: FontWeight.w900, color: Colors.blue),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Button(
                            child: Text("RESUME", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18.sp)),
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
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18.sp),
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
