import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../api/notification_service.dart';

class NotificationUtils {
  static final NotificationService _notificationService = NotificationService();

  static void updateNotificationContent(List<Map<String, dynamic>> suggestMenus, List<Map<String, dynamic>> suggestAvoids) {
    final random = Random();

    // Pilih menu secara acak
    final menuSarapan = suggestMenus.isNotEmpty ? suggestMenus[random.nextInt(suggestMenus.length)] : {};
    final menuMakanSiang = suggestMenus.isNotEmpty ? suggestMenus[random.nextInt(suggestMenus.length)] : {};
    final menuMakanMalam = suggestMenus.isNotEmpty ? suggestMenus[random.nextInt(suggestMenus.length)] : {};

    // Pilih makanan yang harus dihindari secara acak
    final avoidSarapan = suggestAvoids.isNotEmpty ? suggestAvoids[random.nextInt(suggestAvoids.length)] : {};
    final avoidMakanSiang = suggestAvoids.isNotEmpty ? suggestAvoids[random.nextInt(suggestAvoids.length)] : {};
    final avoidMakanMalam = suggestAvoids.isNotEmpty ? suggestAvoids[random.nextInt(suggestAvoids.length)] : {};

    // Format judul dan deskripsi notifikasi
    String titleSarapan = "Ayo Sarapan dengan ${menuSarapan['name']}";
    String descriptionSarapan = "Hindari konsumsi ${avoidSarapan['name']}";

    String titleMakanSiang = "Ayo Makan Siang dengan ${menuMakanSiang['name']}";
    String descriptionMakanSiang = "Hindari konsumsi ${avoidMakanSiang['name']}";

    String titleMakanMalam = "Ayo Makan Malam dengan ${menuMakanMalam['name']}";
    String descriptionMakanMalam = "Hindari konsumsi ${avoidMakanMalam['name']}";

    // Jadwalkan notifikasi
    _notificationService.scheduleDynamicNotifications(
      1,
      titleSarapan,
      descriptionSarapan,
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7, 0),
      'Harian',
    );

    _notificationService.scheduleDynamicNotifications(
      2,
      titleMakanSiang,
      descriptionMakanSiang,
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0),
      'Harian',
    );

    _notificationService.scheduleDynamicNotifications(
      4,
      titleMakanMalam,
      descriptionMakanMalam,
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 0),
      'Harian',
    );
  }
}