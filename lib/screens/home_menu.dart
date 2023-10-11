import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/models/user.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/game_screen.dart';
import 'package:team_hurricane_hockey/services/firebase/user_query.dart';
import 'package:team_hurricane_hockey/services/google_service.dart';
import 'package:team_hurricane_hockey/services/local_storage.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});
  static const routeName = 'home';

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
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
                              BaseNavigator.pushNamed(
                                GameScreen.routeName,
                                args: GameMode.ai,
                              );
                            },
                            child: Text(
                              'VS AI',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0.h),
                        FadeInRightBig(
                          duration: const Duration(milliseconds: 400),
                          child: TextButton(
                            onPressed: () async {
                              final user = AppStorage.instance.getUserData();
                              if (user == null) {
                                final data = await googleLogin();
                                if (data != null) {}
                              }
                            },
                            child: Text(
                              'MULTIPLAYER',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0.h),
                        FadeInRightBig(
                          duration: const Duration(milliseconds: 400),
                          child: TextButton(
                            onPressed: () {
                              BaseNavigator.pushNamed(
                                GameScreen.routeName,
                                args: GameMode.player2,
                              );
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
                            onPressed: () {},
                            child: Text(
                              'Settings',
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
