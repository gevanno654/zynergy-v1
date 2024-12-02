import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'beranda_screen.dart';
import '../api/api_service.dart'; // Import ApiService

class PersonalizationScreen extends StatefulWidget {
  @override
  _PersonalizationScreenState createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> _interests = [
    {'id': 1, 'name': 'Berenang'},
    {'id': 2, 'name': 'Voli'},
    {'id': 3, 'name': 'Jogging'},
    {'id': 4, 'name': 'Yoga'},
    {'id': 5, 'name': 'Aerobik'},
    {'id': 6, 'name': 'Senam'},
    {'id': 7, 'name': 'Bersepeda'},
    {'id': 8, 'name': 'Hiking'},
    {'id': 9, 'name': 'Pilates'},
    {'id': 10, 'name': 'Badminton'},
    {'id': 11, 'name': 'Sepak Bola'},
    {'id': 12, 'name': 'Tenis'},
    {'id': 13, 'name': 'Golf'},
    {'id': 14, 'name': 'Senam Lantai'},
    {'id': 15, 'name': 'Zumba'},
  ];

  List<Map<String, dynamic>> _favorites = [
    {'id': 1, 'name': 'Ayam'},
    {'id': 2, 'name': 'Bebek'},
    {'id': 3, 'name': 'Ikan'},
    {'id': 4, 'name': 'Daging Sapi'},
    {'id': 5, 'name': 'Daging Kambing'},
    {'id': 6, 'name': 'Udang'},
    {'id': 7, 'name': 'Cumi'},
    {'id': 8, 'name': 'Tempe'},
    {'id': 9, 'name': 'Tahu'},
    {'id': 10, 'name': 'Telur'},
    {'id': 11, 'name': 'Kentang'},
    {'id': 12, 'name': 'Nasi'},
    {'id': 13, 'name': 'Mie'},
    {'id': 14, 'name': 'Pasta'},
    {'id': 15, 'name': 'Roti'},
  ];

  List<Map<String, dynamic>> _diseases = [
    {'id': 1, 'name': 'Maag'},
    {'id': 2, 'name': 'Obesitas'},
    {'id': 3, 'name': 'Bipolar'},
    {'id': 4, 'name': 'Insomnia'},
    {'id': 5, 'name': 'Nyeri Otot'},
    {'id': 6, 'name': 'Penyakit Jantung'},
    {'id': 7, 'name': 'Flu'},
    {'id': 8, 'name': 'Batuk'},
    {'id': 9, 'name': 'Radang Usus'},
    {'id': 10, 'name': 'Anemia'},
    {'id': 11, 'name': 'Radang Tenggorokan'},
    {'id': 12, 'name': 'Asma'},
    {'id': 13, 'name': 'Asam Lambung'},
    {'id': 14, 'name': 'Sakit Kepala'},
    {'id': 15, 'name': 'Hipertensi'},
    {'id': 16, 'name': 'Nyeri Sendi'},
  ];

  List<Map<String, dynamic>> _allergies = [
    {'id': 1, 'name': 'Kacang'},
    {'id': 2, 'name': 'Gluten'},
    {'id': 3, 'name': 'Laktosa'},
    {'id': 4, 'name': 'Telur'},
    {'id': 5, 'name': 'Ikan'},
    {'id': 6, 'name': 'Kerang'},
    {'id': 7, 'name': 'Kedelai'},
    {'id': 8, 'name': 'Gandum'},
    {'id': 9, 'name': 'Susu'},
    {'id': 10, 'name': 'Jagung'},
    {'id': 11, 'name': 'Stroberi'},
    {'id': 12, 'name': 'Tomat'},
    {'id': 13, 'name': 'Wijen'},
    {'id': 14, 'name': 'Bawang Putih'},
    {'id': 15, 'name': 'Seledri'},
  ];

  List<int> _selectedInterests = [];
  List<int> _selectedFavorites = [];
  List<int> _selectedDiseases = [];
  List<int> _selectedAllergies = [];

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Tidak perlu mengambil data dari server
  }

  void _toggleItem(int itemId, List<int> selectedList) {
    setState(() {
      if (selectedList.contains(itemId)) {
        selectedList.remove(itemId);
      } else if (selectedList.length < 3) {
        selectedList.add(itemId);
      }
    });
  }

  Future<void> _savePersonalizationData() async {
    try {
      if (_currentPage == 0 && _selectedInterests.isEmpty) {
        // Show error dialog or snackbar
        print("Pilih minimal 1 minat aktivitasmu");
        return;
      }

      if (_currentPage == 1 && _selectedFavorites.isEmpty) {
        // Show error dialog or snackbar
        print("Pilih minimal 1 kesukaan yang kamu konsumsi");
        return;
      }

      if (_currentPage == 2 && _selectedDiseases.isEmpty) {
        // Show error dialog or snackbar
        print("Pilih minimal 1 riwayat penyakitmu");
        return;
      }

      await _apiService.savePersonalizationData(
        interests: _selectedInterests,
        favorites: _selectedFavorites,
        diseases: _selectedDiseases,
        allergies: _selectedAllergies,
      );
    } catch (e) {
      print("Error saving personalization data: $e");
      // Show error dialog or snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 108.0),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: 5,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _buildFirstPage();
                    case 1:
                      return _buildSecondPage();
                    case 2:
                      return _buildThirdPage();
                    case 3:
                      return _buildFourthPage();
                    case 4:
                      return _buildFifthPage();
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 320,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1FC29D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: _currentPage == 4
                  ? () async {
                await _savePersonalizationData();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BerandaScreen()),
                );
              }
                  : () async {
                if (_currentPage == 0 && _selectedInterests.isEmpty) {
                  // Show error dialog or snackbar
                  print("Pilih minimal 1 minat aktivitasmu");
                  return;
                }

                if (_currentPage == 1 && _selectedFavorites.isEmpty) {
                  // Show error dialog or snackbar
                  print("Pilih minimal 1 kesukaan yang kamu konsumsi");
                  return;
                }

                if (_currentPage == 2 && _selectedDiseases.isEmpty) {
                  // Show error dialog or snackbar
                  print("Pilih minimal 1 riwayat penyakitmu");
                  return;
                }

                await _savePersonalizationData();
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: Text(
                _currentPage == 4 ? 'Mulai Sekarang' : 'Selanjutnya',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFirstPage() {
    return _buildPage(
      title: "Pilih Minat\nAktivitasmu",
      description: "Tambahkan personalisasi untuk rekomendasimu",
      items: _interests,
      selectedList: _selectedInterests,
    );
  }

  Widget _buildSecondPage() {
    return _buildPage(
      title: "Pilih Kesukaan\nyang Kamu Konsumsi",
      description: "Tambahkan personalisasi untuk rekomendasimu",
      items: _favorites,
      selectedList: _selectedFavorites,
    );
  }

  Widget _buildThirdPage() {
    return _buildPage(
      title: "Adakah Riwayat\nPenyakitmu?",
      description: "Tambahkan untuk memaksimalkan aplikasi ini",
      items: _diseases,
      selectedList: _selectedDiseases,
    );
  }

  Widget _buildFourthPage() {
    return _buildPage(
      title: "Punya Pantangan\natau Alergi?",
      description: "Tambahkan jika kamu punya pantangan & alergi",
      items: _allergies,
      selectedList: _selectedAllergies,
    );
  }

  Widget _buildFifthPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Semua Sudah Siap!\nMulailah Menjelajah",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "Ingat Kesehatan harus jadi yang utama!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          SvgPicture.asset(
            'assets/personalization.svg',
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required List<Map<String, dynamic>> items,
    required List<int> selectedList,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                description,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pilih minimal 1 dan maksimal 3',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: items.map((item) {
              final int itemId = item['id'];
              final String itemName = item['name'];
              return GestureDetector(
                onTap: () => _toggleItem(itemId, selectedList),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedList.contains(itemId) ? Color(0xFF1FC29D) : Colors.transparent, // Background transparan untuk item yang tidak terpilih
                    borderRadius: BorderRadius.circular(8),
                    border: selectedList.contains(itemId) ? null : Border.all(color: Color(0xFFDFDFDF), width: 1.5), // Outline untuk item yang tidak terpilih
                  ),
                  child: Text(
                    itemName,
                    style: TextStyle(
                      color: selectedList.contains(itemId) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if ((_currentPage == 0 && _selectedInterests.isEmpty) ||
              (_currentPage == 1 && _selectedFavorites.isEmpty) ||
              (_currentPage == 2 && _selectedDiseases.isEmpty))
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Pilih minimal 1 item',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}