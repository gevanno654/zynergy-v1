import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'timezone_helper.dart';
import 'screens/splash_screen.dart';
import 'api/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi timezone
  TimezoneHelper.initializeTimezone();

  // Inisialisasi notifikasi
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const androidInitialization = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettings = InitializationSettings(android: androidInitialization);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Inisialisasi layanan notifikasi
  await NotificationService().initializeNotifications();

  // Jalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zynergy',
      theme: ThemeData(
          fontFamily: 'Geist'
      ),
      home: SplashScreen(),
    );
  }
}
