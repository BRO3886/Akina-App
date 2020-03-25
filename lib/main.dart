import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:project_hestia/Profile/profilePage.dart';
import 'package:flutter/services.dart';
import 'package:project_hestia/screens/news_feed.dart';
import 'package:project_hestia/screens/requests_feed.dart';
import 'package:project_hestia/utils.dart';
import './screens/login.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hestia',
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primaryColor: Color(0xFF00d2d2),
        accentColor: Colors.teal,
        canvasColor: Colors.grey[100],
        cursorColor: Color(0xFF00d2d2),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      ),
      title: 'Hestia',
      home: MyHomeScreen(),
    );
  }
}


class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _pageIndex = 0;
  final pageList = [
    RequestsFeedScreen(),
    NewsFeedScreen(),
  ];

  void _selectPage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        type: BottomNavigationBarType.shifting,
        onTap: _selectPage,
        currentIndex: _pageIndex,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        fixedColor: mainColor,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.library_books, color: mainColor,),
            icon: Icon(
              Icons.library_books,
              // color: Colors.black,
            ),
            title: Text('Feed')
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.language,
              color: mainColor,
            ),
            icon: Icon(
              Icons.language,
              // color: Colors.black,
            ),
            title: Text('News'),
          ),
        ],
      ),
    );
  }
}
