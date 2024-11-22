import 'package:flutter/material.dart';
import 'package:zynergy/core/config/theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scheduled Notification App',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
    );
  }
}
