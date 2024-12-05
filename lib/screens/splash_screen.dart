import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../timezone_helper.dart';
import 'onboarding_screen.dart'; // Import onboarding_screen.dart
import 'login_screen.dart'; // Import login_screen.dart
import 'beranda_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstInstall = prefs.getBool('isFirstInstall') ?? true;
    bool isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;
    String? userToken = prefs.getString('userToken');

    Future.delayed(Duration(seconds: 2), () {
      if (isFirstInstall) {
        // Jika pertama kali menginstal, tampilkan onboarding screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
        prefs.setBool('isFirstInstall', false);
      } else {
        if (isOnboardingComplete) {
          if (userToken != null) {
            // Jika sudah memiliki token, arahkan ke halaman beranda
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BerandaScreen()),
            );
          } else {
            // Jika belum memiliki token, arahkan ke halaman login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }
        } else {
          // Jika onboarding belum selesai, arahkan ke onboarding screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        }
      }
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
      {
        'id': 1,
        'title': 'Notifikasi Sarapan',
        'body': 'Ingatlah untuk sarapan pagi!',
        'hour': 7,
        'minute': 0
      },
      {
        'id': 2,
        'title': 'Notifikasi Makan Siang',
        'body': 'Sudah waktunya makan siang!',
        'hour': 12,
        'minute': 0
      },
      {
        'id': 3,
        'title': 'Notifikasi Minum Penambah Stamina',
        'body': 'Minumlah air untuk menambah stamina!',
        'hour': 15,
        'minute': 0
      },
      {
        'id': 4,
        'title': 'Notifikasi Makan Malam',
        'body': 'Sudah waktunya makan malam!',
        'hour': 18,
        'minute': 0
      },
    ];

    final prefs = await SharedPreferences.getInstance();
    final now = tz.TZDateTime.now(tz.local);

    for (var notification in notifications) {
      // Waktu target untuk notifikasi
      final scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        notification['hour'],
        notification['minute'],
      );

      // Jika waktu yang dijadwalkan telah lewat, tambahkan satu hari
      final nextTime = scheduledTime.isBefore(now)
          ? scheduledTime.add(const Duration(days: 1))
          : scheduledTime;

      // Jadwalkan notifikasi
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notification['id'],
        notification['title'],
        notification['body'],
        nextTime,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      // Simpan ID notifikasi ke SharedPreferences
      await prefs.setInt(
          'notification_${notification['id']}', notification['id']);
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1FC29D),
              Color(0xFF0F5C4A),
            ],
            transform: GradientRotation(
                240 * 3.1415926535 / 180), // 240 derajat dalam radian
          ),
        ),
        child: Center(
          child: Image.asset('assets/images/icon.png', width: 100, height: 100),
        ),
      ),
    );
  }
}
