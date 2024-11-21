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
      'title': 'Kesehatan itu investasi untuk\nmasa depan',
      'description': 'Mulai dari langkah kecil bersama kami, karena hidup aktif dan sehat itu keren!',
      'image': 'assets/page1.svg',
    },
    {
      'title': 'Step 2',
      'description': 'This is the second step of onboarding.',
      'image': 'assets/page2.svg', // Path to SVG image
    },
    {
      'title': 'Step 3',
      'description': 'This is the third step of onboarding.',
      'image': 'assets/page3.svg', // Path to SVG image
    },
    {
      'title': 'Step 4',
      'description': 'This is the fourth step of onboarding.',
      'image': 'assets/page4.svg', // Path to SVG image
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
        // Hapus atau komentari baris ini untuk menghilangkan teks "Onboarding"
        // title: Text('Onboarding'),
        actions: [
          TextButton(
            onPressed: _skipToLastPage,
            child: Text(
              'Lewati',
              style: TextStyle(color: Color(0xff3F3F3F)),
            ),
          ),
        ],
      ),
      body: Column(
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
                  image: _pages[index]['image']!, // Pass the SVG image path
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
                  (index) => _buildDot(index: index),
            ),
          ),
          ElevatedButton(
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
            child: Text(_currentPage == _pages.length - 1 ? 'Get Started' : 'Next'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPage({required String title, required String description, required String image}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            height: 200,
          ),
          SizedBox(height: 20),
          Text(title, textAlign:TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff3F3F3F))),
          SizedBox(height: 20),
          Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0x703F3F3F))),
        ],
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}