import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_hestia/screens/home_screen.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/screens/new_req_screen.dart';
import 'package:project_hestia/screens/news_feed.dart';
import 'package:project_hestia/screens/register.dart';
import 'package:project_hestia/screens/requests_feed.dart';
import 'package:project_hestia/screens/splash_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.grey[100]),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hestia',
      debugShowCheckedModeBanner: false,
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        fontFamily: 'Manrope',
        // textTheme: TextTheme().copyWith(
        //   button: TextStyle(
        //     fontSize: 16,
        //   ),
        //   body2: TextStyle(
        //     fontSize: 16,
        //   ),
        //   title: TextStyle(
        //     fontSize: 18,
        //   ),
        //   body1: TextStyle(
        //     fontSize: 16,
        //   ),
        // ),
        primaryColor: Color(0xFF00d2d2),
        accentColor: Color(0xFF00d2d2),
        canvasColor: Colors.grey[100],
        cursorColor: Color(0xFF00d2d2),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      ),
      home: SplashScreen(),
      routes: {
        MyHomeScreen.routename: (_) => MyHomeScreen(),
        LoginScreen.routename: (_) => LoginScreen(),
        RegsiterScreen.routename: (_) => RegsiterScreen(),
        RequestsFeedScreen.routename: (_) => RequestsFeedScreen(),
        NewsFeedScreen.routename: (_) => NewsFeedScreen(),
        NewRequestScreen.routename: (_) => NewRequestScreen(),
      },
    );
  }
}
