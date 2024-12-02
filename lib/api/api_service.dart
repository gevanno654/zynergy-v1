import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_response.dart';
import 'notification_service.dart';

class ApiService {
  static const String baseUrl = 'https://api-zynergy.gevannoyoh.com/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final NotificationService _notificationService = NotificationService();

  Future<ApiResponse> register(String name, String email, String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      }),
    );

    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> verifyEmail(String otp) async {
    try {
      final token = await getToken();
      if (token == null) {
        return ApiResponse(success: false, message: 'Token not found', data: null);
      }

      final response = await http.post(
        Uri.parse('$baseUrl/verify-email'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'otp': otp}),
      );

      final responseData = jsonDecode(response.body);
      return ApiResponse.fromJson(responseData);
    } catch (e) {
      return ApiResponse(success: false, message: 'Failed to verify email', data: null);
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_data'); // Hapus data pengguna saat logout
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception('Failed to logout: ${responseBody['message'] ?? 'Unknown error'}');
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      await _storage.write(key: 'user_data', value: jsonEncode(userData)); // Simpan data pengguna secara lokal
      return userData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>?> getLocalUserData() async {
    final userDataString = await _storage.read(key: 'user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getInterests() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/personalize/interests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load interests');
    }
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/personalize/favorites'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<List<Map<String, dynamic>>> getDiseases() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/diseases'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load diseases');
    }
  }

  Future<List<Map<String, dynamic>>> getAllergies() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/allergies'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load allergies');
    }
  }

  Future<void> savePersonalizationData({
    required List<int> interests,
    required List<int> favorites,
    required List<int> diseases,
    required List<int> allergies,
  }) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/save-personalization'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'interests': interests,
        'favorites': favorites,
        'diseases': diseases,
        'allergies': allergies,
      }),
    );

    if (response.statusCode != 200) {
      final responseBody = jsonDecode(response.body);
      throw Exception('Failed to save personalization data: ${responseBody['message'] ?? 'Unknown error'}');
    }
  }

  // API Reminders
  Future<int> saveMealReminder(Map<String, dynamic> mealReminder) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    // Log the meal reminder data to check for null values
    print('Meal Reminder Data: $mealReminder');

    // Ensure all required fields have valid values
    if (mealReminder['meal_name'] == null || mealReminder['meal_name'].isEmpty) {
      throw Exception('Meal name is required');
    }
    if (mealReminder['meal_hour'] == null || mealReminder['meal_hour'] < 0 || mealReminder['meal_hour'] > 23) {
      throw Exception('Meal hour must be between 0 and 23');
    }
    if (mealReminder['meal_minute'] == null || mealReminder['meal_minute'] < 0 || mealReminder['meal_minute'] > 59) {
      throw Exception('Meal minute must be between 0 and 59');
    }
    if (mealReminder['meal_frequency'] == null || (mealReminder['meal_frequency'] != 0 && mealReminder['meal_frequency'] != 1)) {
      throw Exception('Meal frequency must be 0 (once) or 1 (daily)');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/meal-reminders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(mealReminder),
    );

    if (response.statusCode != 201) {
      try {
        final responseBody = jsonDecode(response.body);
        throw Exception('Failed to save meal reminder: ${responseBody['message'] ?? 'Unknown error'}');
      } catch (e) {
        throw Exception('Failed to save meal reminder: ${response.body}');
      }
    } else {
      final responseData = jsonDecode(response.body);
      final int id = responseData['id']; // Ambil id dari respons API

      // Schedule notification after successfully saving meal reminder
      final now = DateTime.now();
      final mealHour = mealReminder['meal_hour'];
      final mealMinute = mealReminder['meal_minute'];
      final mealFrequency = mealReminder['meal_frequency'];

      DateTime scheduledDate = DateTime(now.year, now.month, now.day, mealHour, mealMinute);

      if (scheduledDate.isBefore(now)) {
        if (mealFrequency == 0) {
          scheduledDate = scheduledDate.add(Duration(days: 1));
        }
      }

      print('Scheduling notification: id=$id, frequency=$mealFrequency');
      _notificationService.scheduleNotification(
        id, // Gunakan id sebagai notification_id
        'Pengingat Makan',
        'Ingatlah untuk makan sesuai jadwal!',
        scheduledDate,
        mealFrequency == 1 ? 'Harian' : 'Sekali',
      );

      return id; // Kembalikan id yang baru saja disimpan
    }
  }

  Future<void> updateMealReminder(int id, Map<String, dynamic> mealReminder) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/meal-reminders/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(mealReminder),
    );

    if (response.statusCode != 200) {
      try {
        final responseBody = jsonDecode(response.body);
        throw Exception('Failed to update meal reminder: ${responseBody['message'] ?? 'Unknown error'}');
      } catch (e) {
        throw Exception('Failed to update meal reminder: ${response.body}');
      }
    }
  }

  Future<void> updateToggleValue(int id, int toggleValue) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/meal-reminders/$id/toggle'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'toggle_value': toggleValue}),
    );

    if (response.statusCode != 200) {
      try {
        final responseBody = jsonDecode(response.body);
        throw Exception('Failed to update toggle value: ${responseBody['message'] ?? 'Unknown error'}');
      } catch (e) {
        throw Exception('Failed to update toggle value: ${response.body}');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getSpecialSchedules() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/meal-reminders'), // Pastikan URL ini benar
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      try {
        final responseBody = jsonDecode(response.body);
        throw Exception('Failed to load special schedules: ${responseBody['message'] ?? 'Unknown error'}');
      } catch (e) {
        throw Exception('Failed to load special schedules: ${response.body}');
      }
    }
  }

  Future<void> deleteMealReminder(int id) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/meal-reminders/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete meal reminder');
    }
  }

  Future<ApiResponse> saveSleepReminder(Map<String, dynamic> sleepReminder) async {
    final token = await getToken();
    if (token == null) {
      return ApiResponse(success: false, message: 'Token not found', data: null);
    }

    final response = await http.post(
      Uri.parse('$baseUrl/sleep-reminders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sleepReminder),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return ApiResponse(success: true, message: 'Success', data: data);
    } else {
      return ApiResponse(success: false, message: 'Failed to fetch sleep reminders', data: null);
    }
  }

  Future<ApiResponse> updateSleepReminder(int id, Map<String, dynamic> sleepReminder) async {
    final token = await getToken();
    if (token == null) {
      return ApiResponse(success: false, message: 'Token not found', data: null);
    }

    final response = await http.put(
      Uri.parse('$baseUrl/sleep-reminders/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sleepReminder),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ApiResponse(success: true, message: 'Success', data: data);
    } else {
      return ApiResponse(success: false, message: 'Failed to fetch sleep reminders', data: null);
    }
  }

  Future<ApiResponse> getSleepReminders() async {
    final token = await getToken();
    if (token == null) {
      return ApiResponse(success: false, message: 'Token not found', data: null);
    }

    final response = await http.get(
      Uri.parse('$baseUrl/sleep-reminders'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ApiResponse(success: true, message: 'Success', data: data);
    } else {
      return ApiResponse(success: false, message: 'Failed to fetch sleep reminders', data: null);
    }
  }
}