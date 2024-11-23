import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zynergy/core/config/assets/app_vectors.dart';
import 'package:zynergy/core/config/theme/app_colors.dart';
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
    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity, // Full device width
            height: 240, // Fixed height for the header
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.7, -1), // near the top right
                radius: 1,

                colors: [
                  Color(0xFF4AF5CE), // Teal gradient start
                  AppColors.primary, // Teal-blue gradient end
                ],
                stops: <double>[0.0, 1.0],
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Health Condition
                  const Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.teal),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dela April Liana",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Kondisi Sehat Sekali",
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1),
                  // Reminders
                  ListTile(
                    leading: Icon(Icons.notifications, color: Colors.grey[700]),
                    title: const Text("Pengingat"),
                    trailing: const Text("On"),
                  ),
                  const Divider(height: 1),
                  // Alarm
                  ListTile(
                    leading: Icon(Icons.alarm, color: Colors.grey[700]),
                    title: const Text("Alarm"),
                    trailing: const Text("On"),
                  ),
                  const Divider(height: 1),
                  // Contact Us
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.grey[700]),
                    title: const Text("Hubungi Kami"),
                  ),
                  const Spacer(),
                  // Logout Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text("Keluar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Social Media Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.facebook),
                        onPressed: () {},
                        color: Colors.blue,
                      ),
                      IconButton(
                        icon: SvgPicture.asset(AppVectors.iconInstagram),
                        onPressed: () {},
                        color: Colors.pink,
                      ),
                      IconButton(
                        icon: const Icon(Icons.code),
                        onPressed: () {},
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
