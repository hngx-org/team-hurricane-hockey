import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/difficulty_screen.dart';
import 'package:team_hurricane_hockey/screens/game_screen.dart';
import 'package:team_hurricane_hockey/screens/widgets/button.dart';
import 'package:team_hurricane_hockey/sound_control.dart';

class GameModeScreen extends StatefulWidget {
  static const routeName = "game_mode";
  const GameModeScreen({super.key});

  @override
  State<GameModeScreen> createState() => _GameModeScreenState();
}

class _GameModeScreenState extends State<GameModeScreen> {
  SoundControl sound = SoundControl();
  final p = Provider.of<MyProvider>(BaseNavigator.currentContext);

  final _vsAI = 'AI';
  final _vsOnline = 'Multiplayer';
  final _vsLocal = 'Player2';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/retro_BG.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.fromLTRB(24.0.w, 24.0.h, 24.0.w, 0.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                //  mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: FittedBox(
                      child: Text(
                        'GAME MODE',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontSize: 32.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          sound.onButtonPressed();
                          // controller.playSfx();
                          if (p.vsMode == _vsAI) {
                            BaseNavigator.pushNamed(DifficultyScreen.routeName);
                          } else if (p.vsMode == _vsLocal) {
                            BaseNavigator.pushNamed(
                              GameScreen.routeName,
                              args: {
                                "mode": GameMode.player2,
                              },
                            );
                          } else if (p.vsMode == _vsOnline) {
                            // BaseNavigator.pushNamed(
                            //   GameScreen.routeName,
                            //   args: {
                            //     "gameId": s["gameId"],
                            //     "mode": GameMode.multiplayer,
                            //     "opponentId": s["opponentId"],
                            //     "playerId": user!.id!,
                            //   },
                            // );
                          }

                          p.updateGameMode(5);
                        },
                        child: Text(
                          'BEST OF 5',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      TextButton(
                        onPressed: () {
                          sound.onButtonPressed();
                          // controller.playSfx();
                          if (p.vsMode == _vsAI) {
                            BaseNavigator.pushNamed(DifficultyScreen.routeName);
                          } else if (p.vsMode == _vsLocal) {
                            BaseNavigator.pushNamed(
                              GameScreen.routeName,
                              args: {
                                "mode": GameMode.player2,
                              },
                            );
                          } else if (p.vsMode == _vsOnline) {
                            // BaseNavigator.pushNamed(
                            //   GameScreen.routeName,
                            //   args: {
                            //     "gameId": s["gameId"],
                            //     "mode": GameMode.multiplayer,
                            //     "opponentId": s["opponentId"],
                            //     "playerId": user!.id!,
                            //   },
                            // );
                          }
                          p.updateGameMode(7);
                        },
                        child: Text(
                          'BEST OF 7',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      TextButton(
                        onPressed: () {
                          sound.onButtonPressed();
                          // controller.playSfx();
                          if (p.vsMode == _vsAI) {
                            BaseNavigator.pushNamed(DifficultyScreen.routeName);
                          } else if (p.vsMode == _vsLocal) {
                            BaseNavigator.pushNamed(
                              GameScreen.routeName,
                              args: {
                                "mode": GameMode.player2,
                              },
                            );
                          } else if (p.vsMode == _vsOnline) {
                            // BaseNavigator.pushNamed(
                            //   GameScreen.routeName,
                            //   args: {
                            //     "gameId": s["gameId"],
                            //     "mode": GameMode.multiplayer,
                            //     "opponentId": s["opponentId"],
                            //     "playerId": user!.id!,
                            //   },
                            // );
                          }
                          p.updateGameMode(10);
                        },
                        child: Text(
                          'BEST OF 10',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Center(
                        child: Button(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30.w,
                                ),
                                Text(
                                  "BACK",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24),
                                ),
                              ],
                            ),
                            onTap: () {
                              sound.onButtonPressed();
                              // controller.playSfx();
                              BaseNavigator.pop();
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
