import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/screens/game_screen.dart';
import 'package:team_hurricane_hockey/screens/home_menu.dart';
import 'package:team_hurricane_hockey/screens/paddles_and_puck_screen.dart';
import 'package:team_hurricane_hockey/screens/splash_screen.dart';

class AppRouter {
  static _getPageRoute(
    Widget child, [
    String? routeName,
    dynamic args,
  ]) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        settings: RouteSettings(
          name: routeName,
          arguments: args,
        ),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return _getPageRoute(const SplashScreen());

      case GameScreen.routeName:
        final mode = settings.arguments as GameMode;
        return _getPageRoute(GameScreen(
          gameMode: mode,
        ));

      case HomeMenu.routeName:
        return _getPageRoute(const HomeMenu());
      case PaddlesAndPuckScreen.routeName:
        return _getPageRoute(const PaddlesAndPuckScreen());

      default:
        return _getPageRoute(const SplashScreen());
    }
  }
}
