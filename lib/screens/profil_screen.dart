import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zynergy/core/config/assets/app_vectors.dart';
import 'package:zynergy/core/config/theme/app_colors.dart';
import 'package:zynergy/screens/alarm_screen.dart';
import 'package:zynergy/screens/pengaturan_screen.dart';
import 'login_screen.dart';
import 'informasi_pribadi_screen.dart';
import '../api/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Tambahkan ini

class ProfilScreen extends StatelessWidget {
  final ApiService _apiService = ApiService(); // Buat instance ApiService
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Tambahkan ini

  Future<void> _logout(BuildContext context) async {
    try {
      await _apiService.logout(); // Panggil metode logout dari ApiService
      await _googleSignIn.signOut(); // Tambahkan ini untuk signOut dari Google
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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.7, -1), // near the top right
              radius: 0.4,
              colors: [
                Color(0xFF4AF5CE), // Teal gradient start
                AppColors.primary, // Teal-blue gradient end
              ],
              stops: <double>[0.0, 1.0],
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 240 - 64,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.secondary,
                      child: ClipOval(
                        child: SvgPicture.asset(
                          AppVectors.iconUser, // Replace with your SVG path
                          height:
<<<<<<< Updated upstream
                              100, // Scale the SVG to fit within the CircleAvatar
=======
                          100, // Scale the SVG to fit within the CircleAvatar
>>>>>>> Stashed changes
                          width: 100,
                          fit: BoxFit
                              .cover, // Ensures the SVG scales proportionally
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 28),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Health Status Card
                      InkWell(
                        onTap: () {
                          // Action when the health button is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InformasiPribadiScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: AppColors.lightGrey,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      width: 48,
                                      height: 48,
                                      AppVectors.iconHeart,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  const Column(
                                    crossAxisAlignment:
<<<<<<< Updated upstream
                                        CrossAxisAlignment.start,
=======
                                    CrossAxisAlignment.start,
>>>>>>> Stashed changes
                                    children: [
                                      Text(
                                        "Dela April Liana",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        "Kondisi Sehat Sekali",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.darkGrey,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      // Settings Card
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.lightGrey,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PengaturanScreen()));
                              },
                              leading:
<<<<<<< Updated upstream
                                  SvgPicture.asset(AppVectors.iconStopWatch),
=======
                              SvgPicture.asset(AppVectors.iconStopWatch),
>>>>>>> Stashed changes
                              title: const Text(
                                'Pengingat',
                                style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'On',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.darkGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right,
                                      color: AppColors.darkGrey),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
<<<<<<< Updated upstream
                                            const AlarmScreen()));
=======
                                        const AlarmScreen()));
>>>>>>> Stashed changes
                              },
                              leading: SvgPicture.asset(AppVectors.iconAlarm),
                              title: const Text(
                                'Alarm',
                                style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'On',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.darkGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right,
                                      color: AppColors.darkGrey),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: SvgPicture.asset(AppVectors.iconLetter),
                              title: const Text(
                                'Hubungi Kami',
                                style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.darkGrey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Logout Button
                      ElevatedButton.icon(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Keluar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      // Social Media Section
                      const Text(
                        'Dukung dan Ikuti Kami',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(AppVectors.iconInstagram),
                          const SizedBox(width: 12),
                          _socialButton(AppVectors.iconFacebook),
                          const SizedBox(width: 12),
                          _socialButton(AppVectors.iconTwitter),
                          const SizedBox(width: 12),
                          _socialButton(AppVectors.iconGithub),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
<<<<<<< Updated upstream
=======
      ),
    );
  }

  Widget _socialButton(String icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SvgPicture.asset(
        icon,
        width: 24,
        height: 24,
>>>>>>> Stashed changes
      ),
    );
  }

  Widget _socialButton(String icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SvgPicture.asset(
        icon,
        width: 24,
        height: 24,
      ),
    );
  }
}
