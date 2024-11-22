import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../timezone_helper.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => isOnboardingComplete ? LoginScreen() : OnboardingScreen()),
      );
    });
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _scheduleRepeatingNotifications() async {
    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel_id',
      'Scheduled Notifications',
      channelDescription: 'This channel is for scheduled notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final List<Map<String, dynamic>> notifications = [
      {'id': 1, 'title': 'Notifikasi Sarapan', 'body': 'Ingatlah untuk sarapan pagi!', 'hour': 7, 'minute': 0},
      {'id': 2, 'title': 'Notifikasi Makan Siang', 'body': 'Sudah waktunya makan siang!', 'hour': 12, 'minute': 0},
      {'id': 3, 'title': 'Notifikasi Minum Penambah Stamina', 'body': 'Minumlah air untuk menambah stamina!', 'hour': 15, 'minute': 0},
      {'id': 4, 'title': 'Notifikasi Makan Malam', 'body': 'Sudah waktunya makan malam!', 'hour': 18, 'minute': 0},
    ];

    for (var notification in notifications) {
      final now = DateTime.now();
      final targetTime = DateTime(now.year, now.month, now.day, notification['hour'], notification['minute'], 0);

      tz.TZDateTime scheduledTime;
      if (targetTime.isBefore(now)) {
        scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(days: 1));
        scheduledTime = tz.TZDateTime(tz.local, scheduledTime.year, scheduledTime.month, scheduledTime.day, notification['hour'], notification['minute'], 0);
      } else {
        scheduledTime = tz.TZDateTime(tz.local, targetTime.year, targetTime.month, targetTime.day, notification['hour'], notification['minute'], 0);
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notification['id'],
        notification['title'],
        notification['body'],
        scheduledTime,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _scheduleRepeatingNotifications();
    _checkOnboardingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(size: 100),
      ),
    );
  }
}