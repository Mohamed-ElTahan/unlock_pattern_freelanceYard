import 'package:flutter/material.dart';
import 'unlock_pattern_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unlock Pattern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      home: const UnlockPatternScreen(),
    );
  }
}
