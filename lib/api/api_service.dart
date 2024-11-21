import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_response.dart';

class ApiService {
  static const String baseUrl = 'https://api-zynergy.gevannoyoh.com/api';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

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
}