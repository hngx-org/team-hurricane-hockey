import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hurricane Hockey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        dividerColor: Colors.yellowAccent,
        dividerTheme: const DividerThemeData(space: 1),
      ),
      home: const MyHomePage(),
    );
  }
}
