import 'package:flutter/material.dart';
import '../api/api_service.dart'; // Import ApiService

class InformasiPribadiScreen extends StatefulWidget {
  @override
  _InformasiPribadiScreenState createState() => _InformasiPribadiScreenState();
}

class _InformasiPribadiScreenState extends State<InformasiPribadiScreen> {
  final ApiService _apiService = ApiService(); // Buat instance ApiService
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final localUserData = await _apiService.getLocalUserData();
      if (localUserData != null) {
        setState(() {
          _userData = localUserData;
        });
      } else {
        final userData = await _apiService.getUserData();
        setState(() {
          _userData = userData;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informasi Pribadi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama: ${_userData?['name'] ?? 'Loading...'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${_userData?['email'] ?? 'Loading...'}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}