import 'package:flutter/material.dart';
import '../utils.dart';
import './requests_feed.dart';
import './news_feed.dart';

class MyHomeScreen extends StatefulWidget {
  static const routename = "/homescreen";
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _pageIndex;
  PageController _pageController;

  final pageList = [
    RequestsFeedScreen(),
    NewsFeedScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: pageList,
        controller: _pageController,
        onPageChanged: (newPage) {
          setState(() {
            _pageIndex = newPage;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        type: BottomNavigationBarType.shifting,
        onTap: (index) => _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn),
        currentIndex: _pageIndex,
        // backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: mainColor,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books,
              // color: Colors.black,
            ),
            title: Text('Feed'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.language,
              // color: Colors.black,
            ),
            backgroundColor: Colors.white,
            title: Text('News'),
          ),
        ],
      ),
    );
  }
}
