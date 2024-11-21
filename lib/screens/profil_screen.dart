import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'informasi_pribadi_screen.dart';
import '../api/api_service.dart';

class ProfilScreen extends StatelessWidget {
  final ApiService _apiService = ApiService(); // Buat instance ApiService

  Future<void> _logout(BuildContext context) async {
    try {
      await _apiService.logout(); // Panggil metode logout dari ApiService
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Informasi Pribadi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformasiPribadiScreen()),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _logout(context), // Panggil metode _logout saat tombol ditekan
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }
}