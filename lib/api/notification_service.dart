import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../timezone_helper.dart'; // Import timezone_helper.dart
import '../api/api_service.dart'; // Import ApiService

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();



  NotificationService() {
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones(); // Inisialisasi time zones
    TimezoneHelper.initializeTimezone(); // Inisialisasi timezone dari timezone_helper.dart
  }

  Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      DateTime scheduledDate,
      String frequency,
      ) async {
    tz.TZDateTime scheduledTime;

    if (frequency == 'Harian') {
      scheduledTime = _nextInstanceOfDailyTime(scheduledDate);
    } else {
      scheduledTime = tz.TZDateTime.from(scheduledDate, tz.local);
      if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        // Jika waktu yang dijadwalkan sudah lewat, jadwalkan untuk hari berikutnya
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'custom_channel_id',
          'Custom Notifications',
          channelDescription: 'Channel for custom notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: frequency == 'Harian' ? DateTimeComponents.time : null,
      payload: jsonEncode({
        'id': id,
        'frequency': frequency,
      }),
    );
  }

  // Fungsi untuk mendapatkan waktu notifikasi harian berikutnya
  tz.TZDateTime _nextInstanceOfDailyTime(DateTime scheduledDate) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      scheduledDate.hour,
      scheduledDate.minute,
    );

    // Jika waktu yang dijadwalkan sudah lewat untuk hari ini, jadwalkan untuk besok
    return scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;
  }

  Future<void> updateNotificationToFarFuture(int id) async {
    final farFuture = tz.TZDateTime(
      tz.local,
      2100,
      12,
      31,
      23,
      59,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Pengingat Makan',
      'Jadwal telah dihapus',
      farFuture,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'custom_channel_id',
          'Custom Notifications',
          channelDescription: 'Channel for custom notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future<void> rescheduleNotificationIfNeeded(
      int id, String title, String body, DateTime scheduledDate) async {
    final now = tz.TZDateTime.now(tz.local);

    // Waktu penjadwalan berikutnya
    final nextTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      scheduledDate.hour,
      scheduledDate.minute,
    ).isBefore(now)
        ? tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + 1,
      scheduledDate.hour,
      scheduledDate.minute,
    )
        : tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      scheduledDate.hour,
      scheduledDate.minute,
    );

    // Jadwalkan ulang
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      nextTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'custom_channel_id',
          'Custom Notifications',
          channelDescription: 'Channel for custom notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}