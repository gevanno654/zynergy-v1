import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Tambahkan ini untuk menggunakan CupertinoSwitch
import 'package:flutter_svg/flutter_svg.dart'; // Tambahkan ini untuk menggunakan SVG
import 'pengingat_screen.dart';
import 'artikel_screen.dart';
import 'profil_screen.dart';
import '../api/api_service.dart';
import 'login_screen.dart';
import 'tambah_jadwal_makan.dart'; // Pastikan Anda memiliki file ini
import 'tambah_jadwal_tidur.dart'; // Pastikan Anda memiliki file ini
import 'tambah_jadwal_cek_kesehatan.dart'; // Pastikan Anda memiliki file ini
import 'tambah_jadwal_olahraga.dart'; // Pastikan Anda memiliki file ini
import '../core/config/theme/app_colors.dart'; // Impor app_colors.dart
import '../core/config/strings/app_text.dart'; // Impor app_text.dart
import '../core/config/assets/app_vectors.dart'; // Impor app_vectors.dart
import '../core/config/assets/app_images.dart'; // Impor app_images.dart

class BerandaScreen extends StatefulWidget {
  @override
  _BerandaScreenState createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _currentIndex = 0;
  final _apiService = ApiService();

  final List<Widget> _screens = [
    BerandaContentScreen(),
    PengingatScreen(),
    ArtikelScreen(),
    ProfilScreen(),
  ];

  final List<String> _titles = [
    'Beranda',
    'Pengingat',
    'Artikel',
    'Profil',
  ];

  Future<void> _logout() async {
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
    return WillPopScope(
      onWillPop: () async {
        return false; // Mencegah pengguna kembali ke halaman sebelumnya
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Pengingat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Artikel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          selectedItemColor: AppColors.primary, // Menggunakan AppColors.primary
          unselectedItemColor: Colors.grey, // Warna font yang tidak dipilih
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Gaya font yang dipilih
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Gaya font yang tidak dipilih
          showSelectedLabels: true, // Menampilkan label yang dipilih
          showUnselectedLabels: true, // Menampilkan label yang tidak dipilih
        ),
      ),
    );
  }
}

class BerandaContentScreen extends StatefulWidget {
  @override
  _BerandaContentScreenState createState() => _BerandaContentScreenState();
}

class _BerandaContentScreenState extends State<BerandaContentScreen> {
  final String userName = "John Doe";
  bool _isPengingatMakanEnabled = true;
  bool _isPengingatTidurEnabled = true;
  bool _isDurasiTidurTerbaikEnabled = true;
  bool _isPengingatCekKesehatanEnabled = true;
  bool _isPengingatOlahragaEnabled = true;

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Ini adalah modal"),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Tutup"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayName = userName.split(' ')[0]; // Ambil kata depan

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
          ),
          Positioned(
            top: -90,
            right: -180,
            child: Container(
              width: 500,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment.center,
                  colors: [
                    Color(0xFF2CE4BB),
                    AppColors.primary,
                  ],
                  stops: [0.4, 1.0],
                  radius: 0.3,
                ),
              ),
            ),
          ),
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hai, $displayName",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(AppVectors.iconNotification), // Menggunakan AppVectors.iconNotification
                      onPressed: () => _showModal(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  BerandaText.rekomendasiHariIni, // Menggunakan BerandaText.rekomendasiHariIni
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              _buildCard(
                icon: Icons.info_outline_rounded,
                title: BerandaText.minumAir, // Menggunakan BerandaText.minumAir
              ),
              _buildCard(
                icon: Icons.info_outline_rounded,
                title: BerandaText.peregangan, // Menggunakan BerandaText.peregangan
              ),
              _buildCard(
                icon: Icons.info_outline_rounded,
                title: BerandaText.tidurSiang, // Menggunakan BerandaText.tidurSiang
                showCloseButton: true,
              ),
              _buildCard(
                icon: Icons.info_outline_rounded,
                title: BerandaText.cuacaPanas, // Menggunakan BerandaText.cuacaPanas
                showCloseButton: true,
              ),
              SizedBox(height: 60.0),

              Stack(
                children: [
                  SizedBox(
                    height: 100,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Warna abu-abu
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 0.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 16.0),
                            child: Text(
                              BerandaText.pengingatmu,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkGrey),
                            ),
                          ),
                          _buildReminderCard(context),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 46.0, bottom: 4.0),
                            child: Text(
                              BerandaText.rekomendasiArtikel,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkGrey),
                            ),
                          ),
                          _buildArticleCard(
                            imagePath: 'assets/images/thumbartikel1.png',
                            title: '5 Tips Sehat Ala Gen Z',
                            onPressed: () {
                              // Navigasi ke halaman artikel selengkapnya
                            },
                          ),
                          _buildArticleCard(
                            imagePath: 'assets/images/thumbartikel2.png',
                            title: '5 Cara Meredakan Gangguan Kecemasan Dengan Cepat',
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    bool showCloseButton = false,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      elevation: (0.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 10.0, top: 8.0, bottom: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                icon,
                color: AppColors.primary, // Menggunakan AppColors.primary
              ),
              onPressed: () {

              },
            ),
            SizedBox(width: 4.0), // Jarak antara icon dan title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary, // Menggunakan AppColors.primary
                ),
              ),
            ),
            if (showCloseButton)
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.primary, // Menggunakan AppColors.primary
                ),
                onPressed: () {
                  // Logika untuk menutup card
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: (0.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.lightGrey), // Menggunakan AppColors.lightGrey
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
            child: Column(
              children: [
                Card(
                  color: AppColors.primary, // Menggunakan AppColors.primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 6.0, top: 6.0, bottom: 6.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            AppVectors.iconMakan, // Menggunakan AppVectors.iconMakan
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            'Pengingat Makan', // Menggunakan BerandaText.pengingatMakan
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Transform.scale(
                          scale: 0.9,
                          child: CupertinoSwitch(
                            value: _isPengingatMakanEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isPengingatMakanEnabled = value;
                              });
                            },
                            activeColor: AppColors.lightGrey, // Menggunakan AppColors.lightGrey
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TambahJadwalMakanScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary, // Menggunakan AppColors.primary
                      elevation: (0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: AppColors.primary), // Menggunakan AppColors.primary
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.primary),
                        SizedBox(width: 4.0),
                        Text(
                          ButtonBerandaText.tambahJadwalMakan,
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Card(
          elevation: (0.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.lightGrey), // Menggunakan AppColors.lightGrey
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
            child: Column(
              children: [
                Card(
                  color: AppColors.primary, // Menggunakan AppColors.primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 6.0, top: 6.0, bottom: 6.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            AppVectors.iconTidur, // Menggunakan AppVectors.iconTidur
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            'Pengingat Tidur',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Transform.scale(
                          scale: 0.9,
                          child: CupertinoSwitch(
                            value: _isPengingatTidurEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isPengingatTidurEnabled = value;
                              });
                            },
                            activeColor: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: 60,
                  child: Card(
                    color: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 6.0, top: 6.0, bottom: 6.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(
                              AppVectors.iconTidur,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              PengingatTidurText.durasiTidurTerbaik,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                                Icons.info_rounded,
                                color: Colors.white
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                      BerandaText.infoDurasiTidur,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          ButtonBerandaText.tutup,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: AppColors.primary, // Menggunakan AppColors.primary
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          Transform.scale(
                            scale: 0.9,
                            child: CupertinoSwitch(
                              value: _isDurasiTidurTerbaikEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _isDurasiTidurTerbaikEnabled = value;
                                });
                              },
                              activeColor: AppColors.lightGrey, // Menggunakan AppColors.lightGrey
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TambahJadwalTidurScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary, // Menggunakan AppColors.primary
                      elevation: (0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: AppColors.primary), // Menggunakan AppColors.primary
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.primary), // Menggunakan AppColors.primary
                        SizedBox(width: 4.0),
                        Text(
                          ButtonBerandaText.tambahJadwalTidur, // Menggunakan BerandaText.tambahJadwalTidur
                          style: TextStyle(color: AppColors.primary), // Menggunakan AppColors.primary
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Card(
          elevation: (0.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.lightGrey), // Menggunakan AppColors.lightGrey
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
            child: Column(
              children: [
                Card(
                  color: AppColors.primary, // Menggunakan AppColors.primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 6.0, top: 6.0, bottom: 6.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            AppVectors.iconOlahraga, // Menggunakan AppVectors.iconOlahraga
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            'Pengingat Olahraga',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Transform.scale(
                          scale: 0.9,
                          child: CupertinoSwitch(
                            value: _isPengingatOlahragaEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isPengingatOlahragaEnabled = value;
                              });
                            },
                            activeColor: AppColors.lightGrey, // Menggunakan AppColors.lightGrey
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TambahJadwalOlahragaScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary, // Menggunakan AppColors.primary
                      elevation: (0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: AppColors.primary), // Menggunakan AppColors.primary
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.primary),
                        SizedBox(width: 4.0),
                        Text(
                          ButtonBerandaText.tambahJadwalOlahraga,
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Card(
          elevation: (0.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.lightGrey), // Menggunakan AppColors.lightGrey
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
            child: Column(
              children: [
                Card(
                  color: AppColors.primary, // Menggunakan AppColors.primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 6.0, top: 6.0, bottom: 6.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            AppVectors.iconCheckup,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            'Pengingat Cek Kesehatan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Transform.scale(
                          scale: 0.9,
                          child: CupertinoSwitch(
                            value: _isPengingatCekKesehatanEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isPengingatCekKesehatanEnabled = value;
                              });
                            },
                            activeColor: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TambahJadwalCekKesehatanScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary, // Menggunakan AppColors.primary
                      elevation: (0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: AppColors.primary), // Menggunakan AppColors.primary
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.primary),
                        SizedBox(width: 4.0),
                        Text(
                          ButtonBerandaText.tambahJadwalCheckup,
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
                margin: EdgeInsets.only(left: 10.0, right: 4.0, bottom: 8.0, top: 8.0),
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
                        offset: Offset(0, 0)
                    ),
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
                              backgroundColor: AppColors.primary, // Menggunakan AppColors.primary
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