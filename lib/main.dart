import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/app_router.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: BaseNavigator.key,
            title: 'Hurricane Hockey',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              dividerColor: Colors.yellowAccent,
              dividerTheme: const DividerThemeData(space: 1),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  side: BorderSide(
                    color: Colors.white,
                    width: 2.0.w,
                  ),
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                ),
              ),
              textTheme: TextTheme(
                headlineLarge: GoogleFonts.pressStart2p(
                  fontSize: 40.0.sp,
                  color: Colors.white,
                  // fontWeight: FontWeight.w900,
                ),
                labelMedium: GoogleFonts.tektur(
                  fontSize: 32.0.sp,
                  color: Colors.white,
                ),
              ),
            ),
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: SplashScreen.routeName,
          );
        });
  }
}
