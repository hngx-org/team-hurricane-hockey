import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/game_screen.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});
  static const routeName = 'home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.maybeSizeOf(context)!.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/retro_BG.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          // color: Colors.blue[50],
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // color: Colors.black,
                  alignment: Alignment.center,
                  height: 170.0,
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
                        duration: const Duration(milliseconds: 800),
                        child: TextButton(
                          onPressed: () {
                            BaseNavigator.pushNamed(GameScreen.routeName);
                          },
                          child: Text(
                            'VS AI',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      FadeInRightBig(
                        duration: const Duration(milliseconds: 1600),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'VS PLAYER 2',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      FadeInRightBig(
                        duration: const Duration(milliseconds: 2400),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Settings',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 100.0),
                    ],
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
