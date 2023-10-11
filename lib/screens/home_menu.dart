import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/game_screen.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});
  static const routeName = 'home';
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
            padding:  EdgeInsets.fromLTRB(24.0.w, 24.0.h, 24.0.w, 0.0),
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
