import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Kesehatan itu investasi\nuntuk masa depan',
      'description': 'Mulai dari langkah kecil bersama kami,\nkarena hidup aktif dan sehat itu keren!',
      'image': 'assets/page1.svg',
    },
    {
      'title': 'Ngga ada kata terlambat\nbuat mulai sehat',
      'description': 'Ambil langkah pertama dengan kami,\ndan rasakan manfaatnya di setiap harinya!',
      'image': 'assets/page2.svg',
    },
    {
      'title': 'Temukan cara-cara seru buat jaga\ntubuh dan pikiran tetap sehat',
      'description': 'Siap untuk hidup lebih baik, lebih aktif, dan lebih bahagia',
      'image': 'assets/page3.svg',
    },
    {
      'title': 'Jadilah generasi yang peduli\ndengan kesehatan diri',
      'description': 'Kebiasaan sehat untuk masa depan yang lebih cerah',
      'image': 'assets/page4.svg',
    },
  ];

  void _skipToLastPage() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _currentPage == _pages.length - 1
            ? null
            : [
          TextButton(
            onPressed: _skipToLastPage,
            child: Text(
              'Lewati',
              style: TextStyle(color: Color(0xff3F3F3F), fontSize: 16),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(
                      title: _pages[index]['title']!,
                      description: _pages[index]['description']!,
                      image: _pages[index]['image']!,
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 320,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1FC29D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  onPressed: _currentPage == _pages.length - 1
                      ? () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isOnboardingComplete', true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                      : () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Memulai' : 'Selanjutnya',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => _buildDot(index: index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({required String title, required String description, required String image}) {
    return Padding(
      // padding: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.only(bottom: 50.0, left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 40.0),
            child: SvgPicture.asset(
              image,
              height: 275,
            ),
          ),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xff3F3F3F))),
          SizedBox(height: 20),
          Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0x703F3F3F))),
        ],
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 6),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? Color(0xff1FC29D) : Color(0x203F3F3F),
        borderRadius: BorderRadius.circular(9999),
      ),
    );
  }
}