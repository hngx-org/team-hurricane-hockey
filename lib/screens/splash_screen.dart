import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/home_menu.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool firstSplash = true;
  @override
  void initState() {
    super.initState();
    initCheck();
  }

  initCheck() async {
    await Future.delayed(const Duration(seconds: 3));
    firstSplash = false;
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));
    BaseNavigator.pushNamedAndclear(HomeMenu.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstSplash ? Colors.white : Colors.black,
      body: SafeArea(
        child: Builder(builder: (context) {
          if (firstSplash) {
            return FadeIn(
              duration: const Duration(seconds: 2),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(
                        "assets/images/hng.jpg",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HNG",
                          style: GoogleFonts.lato(
                            fontSize: 30.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Games",
                          style: GoogleFonts.lato(
                            fontSize: 30.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/retro_BG.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
            // color: Colors.blue[50],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInLeft(
                    duration: const Duration(milliseconds: 700),
                    child: Text(
                      'HOCKEY',
                      style: GoogleFonts.tektur(
                        fontSize: 65.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  FadeInRight(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      'CHALLENGE',
                      style: GoogleFonts.tektur(
                        fontSize: 65.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
