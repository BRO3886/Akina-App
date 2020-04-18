import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/screens/home_screen.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  static const routename = "/splashscreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

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
  
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final sp = SharedPrefsCustom();
  String checkDeviceID, checkUserToken, deviceID;

  @override
  void initState() {
    super.initState();

    firebaseMessaging.getToken().then((token) {
      update(token);
    });
    checkToken();
  }

  checkToken() async{
    checkDeviceID = await sp.getDeviceTokenID();
    checkUserToken = await sp.getToken();
    if(checkDeviceID == null && checkUserToken!=null){
      registerDevice();
    }
    else{
      checkLoginStatus();
    }
  }

  update(String token) {
    print("FCM token is "+token);
    setState(() {
      deviceID = token;
    });
  }

  Map<String, String> body_register_device = {
    "user_token":"1",
    "registration_id":"123458"
  };

  registerDevice() async {
    body_register_device['user_token'] = checkUserToken;
    body_register_device['registration_id'] = deviceID;

    print("Body sent to register device is "+body_register_device.toString());

    try {
      final response = await http.post(
        URL_REGISTER_DEVICE,
        // headers: {
        //   HttpHeaders.contentTypeHeader: 'application/json',
        // },
        body: body_register_device,
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Response of register device is"+responseBody.toString());
      print("Response code is "+response.statusCode.toString());
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed(MyHomeScreen.routename);
      }
    } catch (e) {
      print(e.toString());
    }
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
