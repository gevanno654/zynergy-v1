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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 64),
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
                              100, // Scale the SVG to fit within the CircleAvatar
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
                                        CrossAxisAlignment.start,
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
                              leading:
                                  SvgPicture.asset(AppVectors.iconStopWatch),
                              title: const Text(
                                'Pengingat',
                                style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'On',
                                    style: TextStyle(
                                        color: AppColors.darkGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.chevron_right,
                                      color: AppColors.darkGrey),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: SvgPicture.asset(AppVectors.iconAlarm),
                              title: const Text(
                                'Alarm',
                                style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'On',
                                    style: TextStyle(
                                        color: AppColors.darkGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 4),
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
                              trailing: Icon(Icons.chevron_right,
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
                          backgroundColor: Colors.red,
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

class CurvedShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.black
      ..style = PaintingStyle.fill;

    final path = Path();

    // Starting point at top-left
    path.moveTo(0, 24);

    // Top-left curve
    path.quadraticBezierTo(0, 0, 24, 0);

    // Line to top-right minus corner
    path.lineTo(size.width - 24, 0);

    // Top-right curve
    path.quadraticBezierTo(size.width, 0, size.width, 24);

    // Line to bottom-right
    path.lineTo(size.width, size.height);

    // Line to bottom-left
    path.lineTo(0, size.height);

    // Close the path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
