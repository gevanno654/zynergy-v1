import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zynergy/core/config/assets/app_images.dart';
import 'package:zynergy/core/config/assets/app_vectors.dart';
import 'package:zynergy/core/config/theme/app_colors.dart';
import 'package:zynergy/core/config/strings/app_text.dart';

class ArtikelScreen extends StatelessWidget {
  const ArtikelScreen({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {},
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Article Count and Filter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Menampilkan 400 Artikel',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: SvgPicture.asset(AppVectors.iconFilter),
                          label: const Text(
                            'Filter',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
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
                    children: [
                      Text(
                        'Rekomendasi Artikel Untukmu',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 0.0),
                      _buildArticleCard(
                        imagePath: 'assets/images/thumbartikel1.png',
                        title: '5 Tips Sehat Ala Gen Z',
                        onPressed: () {
                          // Navigasi ke halaman artikel selengkapnya
                        },
                      ),
                      _buildArticleCard(
                        imagePath: 'assets/images/thumbartikel2.png',
                        title:
                            '5 Cara Meredakan Gangguan Kecemasan dengan Cepat',
                        onPressed: () {
                          // Navigasi ke halaman artikel selengkapnya
                        },
                      ),
                      _buildArticleCard(
                        imagePath: 'assets/images/thumbartikel3.png',
                        title: 'Nutrisi dan Manfaat Kesehatan Wortel',
                        onPressed: () {
                          // Navigasi ke halaman artikel selengkapnya
                        },
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

  Widget _buildArticleCard({
    required String imagePath,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: (0.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          height: 130,
          child: Row(
            children: [
              Container(
                width: 110,
                height: 110,
                margin: EdgeInsets.only(
                    left: 10.0, right: 4.0, bottom: 8.0, top: 8.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 0)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 130,
                          height: 34,
                          child: ElevatedButton(
                            onPressed: onPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors
                                  .primary, // Menggunakan AppColors.primary
                              foregroundColor: Colors.white,
                              elevation: (0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              ButtonBerandaText.selengkapnya,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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
}
