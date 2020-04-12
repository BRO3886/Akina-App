import 'package:flutter/material.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/explore_screen.dart';
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
    ExploreScreen(),
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
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn),
        currentIndex: _pageIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: mainColor,
        iconSize: 25,
        unselectedFontSize: 0,
        backgroundColor: colorWhite,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_view_day,
              // color: Colors.black,
            ),
            title: Text('Feed'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
              // color: Colors.black,
            ),
            backgroundColor: Colors.white,
            title: Text('Explore'),
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
