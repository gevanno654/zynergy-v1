import 'package:flutter/material.dart';
import 'beranda_screen.dart';

class PersonalizationScreen extends StatefulWidget {
  @override
  _PersonalizationScreenState createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Personalization Step 1',
      'description': 'This is the first step of personalization.',
    },
    {
      'title': 'Personalization Step 2',
      'description': 'This is the second step of personalization.',
    },
    {
      'title': 'Personalization Step 3',
      'description': 'This is the third step of personalization.',
    },
    {
      'title': 'Personalization Step 4',
      'description': 'This is the fourth step of personalization.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personalization')),
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
                ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BerandaScreen()),
              );
            }
                : () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            child: Text(_currentPage == _pages.length - 1 ? 'Finish' : 'Next'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPage({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
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