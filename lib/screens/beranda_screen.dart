import 'package:flutter/material.dart';
import 'pengingat_screen.dart';
import 'artikel_screen.dart';
import 'profil_screen.dart';
import '../api/api_service.dart';
import 'login_screen.dart';

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
          selectedItemColor: Color(0xFF1FC29D), // Warna font yang dipilih
          unselectedItemColor: Colors.grey, // Warna font yang tidak dipilih
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold), // Gaya font yang dipilih
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal), // Gaya font yang tidak dipilih
          showSelectedLabels: true, // Menampilkan label yang dipilih
          showUnselectedLabels: true, // Menampilkan label yang tidak dipilih
        ),
      ),
    );
  }
}

class BerandaContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Ini adalah halaman Beranda'),
    );
  }
}
