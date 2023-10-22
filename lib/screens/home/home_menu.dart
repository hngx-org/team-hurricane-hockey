import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/models/user.dart';
import 'package:team_hurricane_hockey/models/waitlist_req.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/game_mode_screen.dart';
import 'package:team_hurricane_hockey/screens/game_screen.dart';
import 'package:team_hurricane_hockey/screens/widgets/settings_dialog.dart';
import 'package:team_hurricane_hockey/services/firebase/user_query.dart';
import 'package:team_hurricane_hockey/services/firebase/waitlist_query.dart';
import 'package:team_hurricane_hockey/services/google_service.dart';
import 'package:team_hurricane_hockey/services/local_storage.dart';
import 'package:team_hurricane_hockey/sound_control.dart';

import 'overlays/home_overlays.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  static const routeName = 'home';

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> with WidgetsBindingObserver {
  var user = AppStorage.instance.getUserData();

  multiplayerProcess(Waitlist waitlist) async {
    final s = await WaitlistQuery.instance.checkIntoWaitlist(
      waitlist,
      user!.id!,
    );
    if (s) {
      final s = await HomeOverlays().wailistDialog(user!);
      WaitlistQuery.instance.deleteUserOnWaitlist(user!.id!);
      if (mounted) {
        if (s != null) {
          await Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            Navigator.pushNamed(context, GameScreen.routeName, arguments: {
              "gameId": s["gameId"],
              "mode": GameMode.multiplayer,
              "opponentId": s["opponentId"],
              "playerId": user!.id!,
              "isPlayer2": s["player2"],
            });
          });
        }
      }
    }
  }

  ValueNotifier multiPlayerPressed = ValueNotifier(false);
  Future<UserData?> googleLogin() async {
    try {
      await AuthRepository.instance.logOut();

      final result = await AuthRepository.instance.googleAuth();
      if (result.item1 != null) {
        final data = result.item1;
        assert(data!.email != null);
        assert(data!.displayName != null);
        assert(data!.uid.isNotEmpty);

        UserData userData = UserData(
          email: data?.email,
          name: data?.displayName,
          image: data?.photoURL,
          id: data?.uid,
        );

        final s = await UserQuery.instance.saveUser(userData);

        if (s) {
          AppStorage.instance.saveUser(userData.toJson());
          user = userData;
          return userData;
        }

        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  SoundControl sound = SoundControl();
  final p = Provider.of<MyProvider>(BaseNavigator.currentContext);
  final _vsAI = 'AI';
  final _vsOnline = 'Multiplayer';
  final _vsLocal = 'Player2';

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (p.isMusicPlaying) sound.initialPlayBgMusic();
    sound.loadSfx();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  FittedBox(
                    child: Text(
                      'HOCKEY\n\nCHALLENGE',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInRightBig(
                          duration: const Duration(milliseconds: 200),
                          child: TextButton(
                            onPressed: () {
                              sound.onButtonPressed();
                              BaseNavigator.pushNamed(GameModeScreen.routeName);
                              p.updateVsMode(_vsAI);
                            },
                            child: Text(
                              'VS AI',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0.h),
                        ValueListenableBuilder(
                          valueListenable: multiPlayerPressed,
                          builder: (context, pressed, _) {
                            if (pressed) {
                              return FadeInRightBig(
                                duration: const Duration(milliseconds: 400),
                                child: TextButton(
                                  onPressed: () async {},
                                  child: Text(
                                    'MULTIPLAYER',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                              );
                            }
                            return FadeInRightBig(
                              duration: const Duration(milliseconds: 400),
                              child: TextButton(
                                onPressed: () async {
                                  if (pressed) {
                                    return;
                                  } else {
                                    multiPlayerPressed.value = true;
                                    setState(() {});
                                    Waitlist waitlist = Waitlist(
                                      name: user?.name,
                                      id: user?.id,
                                      image: user?.image,
                                      email: user?.email,
                                      isReady: true,
                                    );
                                    if (user == null) {
                                      final data = await googleLogin();
                                      if (data != null) {
                                        multiplayerProcess(waitlist);
                                      }
                                    } else {
                                      multiplayerProcess(waitlist);
                                    }
                                    p.updateVsMode(_vsOnline);
                                    multiPlayerPressed.value = false;
                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  'MULTIPLAYER',
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24.0.h),
                        FadeInRightBig(
                          duration: const Duration(milliseconds: 400),
                          child: TextButton(
                            onPressed: () {
                              sound.onButtonPressed();
                              BaseNavigator.pushNamed(GameModeScreen.routeName);
                              p.updateVsMode(_vsLocal);
                            },
                            child: Text(
                              'VS PLAYER 2',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0.h),
                        FadeInRightBig(
                          duration: const Duration(milliseconds: 800),
                          child: TextButton(
                            onPressed: () {
                              sound.onButtonPressed();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const SettingsDialog();
                                },
                              );
                            },
                            child: Text(
                              'SETTINGS',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 100.0.h),
                      ],
                    ),
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
