import 'package:flutter/material.dart';
import 'package:ircell/login/splash_screen.dart';
import 'package:ircell/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IR CELL',
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}