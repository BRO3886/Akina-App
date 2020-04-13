import 'package:flutter/material.dart';
import 'package:project_hestia/screens/home_screen.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

class SplashScreen extends StatefulWidget {
  static const routename = "/splashscreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final sp = SharedPrefsCustom();

  checkLoginStatus() async {
    final status = await sp.getLoggedInStatus();
    if (status == false || status == null) {
      Future.delayed(
          Duration(seconds: 1),
          () => Navigator.of(context)
              .pushReplacementNamed(LoginScreen.routename));
    } else {
      Future.delayed(
          Duration(seconds: 1),
          () => Navigator.of(context)
              .pushReplacementNamed(MyHomeScreen.routename));
    }
  }

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/hestia_logo.png",
          height: 100,
        ),
      ),
    );
  }
}
