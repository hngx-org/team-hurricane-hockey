import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/game_screen.dart';
import 'package:team_hurricane_hockey/screens/widgets/button.dart';
import 'package:team_hurricane_hockey/sound_control.dart';

class DifficultyScreen extends StatefulWidget {
  static const routeName = "difficulty";
  const DifficultyScreen({super.key});

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  SoundControl controller = SoundControl();
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
                        'DIFFICULTY',
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
                          controller.playSfx();
                          BaseNavigator.pushNamedAndReplace(
                            GameScreen.routeName,
                            args: {
                              "mode": GameMode.ai,
                              'speed': 3.0,
                            },
                          );
                        },
                        child: Text(
                          'EASY',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      TextButton(
                        onPressed: () {
                          controller.playSfx();
                          BaseNavigator.pushNamedAndReplace(
                            GameScreen.routeName,
                            args: {
                              "mode": GameMode.ai,
                              'speed': 5.0,
                            },
                          );
                        },
                        child: Text(
                          'MEDIUM',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      TextButton(
                        onPressed: () {
                          controller.playSfx();
                          BaseNavigator.pushNamedAndReplace(
                            GameScreen.routeName,
                            args: {
                              "mode": GameMode.ai,
                              'speed': 7.0,
                            },
                          );
                        },
                        child: Text(
                          'HARD',
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
                              BaseNavigator.pop();
                            }),
                      ),
                      SizedBox(height: 100.0.h),
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
