import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/home_screen.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

class EmailVerificationPage extends StatefulWidget {
  static const routename = "/email-verification";

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  Future _login(String email, String password) async {
    print(email + password);
    final body = {"email": email, "password": password};
    try {
      String msg = "";
      final response = await http.post(URL_USER_LOGIN, body: body);
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Response of login is " + responseBody.toString());
      if (responseBody.containsKey("Error")) {
        msg =
            responseBody["Error"] + ". Please check your email and try again.";
      } else if (responseBody.containsKey("Status")) {
        msg = responseBody["Status"] + ". Please enter correct password.";
      }
      if (msg != "") {
        showDialog(
          context: context,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text('Error'),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                textColor: mainColor,
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      } else {
        if (response.statusCode == 200) {
          print("logged in successfully ----------------------------------------------------- responsebody is "+responseBody.toString());
          final sp = SharedPrefsCustom();
          sp.setUserEmail(responseBody['email']);
          sp.setUserName(responseBody["name"]);
          sp.setPhone(responseBody["phone"]);
          sp.setUserId(responseBody["id"]);
          sp.setToken(responseBody["Token"]);
          sp.setLoggedInStatus(true);
          sp.setShopStatus(false);
          sp.setRequestStatus(false);
          registerDevice(responseBody['Token']);
          // Navigator.of(context).pushReplacementNamed(MyHomeScreen.routename);
          // Navigator.of(context).pushReplacementNamed(MyHomeScreen.routename);
          print("logged in successfully");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkVerificationAndLogin(String email, String password) async {
    print(email + password);
    bool emailIsVerified = false;
    try {
      final response = await http.post(
        URL_USER_VERIFY,
        body: {
          'email': email,
        },
      );
      if (response.statusCode == 200) {
        emailIsVerified = true;
        _login(email, password);
        return emailIsVerified;
      } else {
        emailIsVerified = false;
        return emailIsVerified;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  String deviceID;

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

  registerDevice(String tokenID) async {
    print("Token id is "+tokenID);
    body_register_device['user_token'] = tokenID;
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
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    return Scaffold(
      body: StreamBuilder(
        stream: Stream.periodic(Duration(seconds: 5)).asyncMap((i) =>
            checkVerificationAndLogin(userInfo['email'], userInfo['password'])),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return EmailVerifed();
            } else {
              return EmailNotVerified(
                name: userInfo["name"],
                email: userInfo["email"],
              );
            }
          }
          return EmailNotVerified(
            name: userInfo["name"],
            email: userInfo["email"],
          );
        },
      ),
    );
  }
}

class EmailVerifed extends StatelessWidget {
  const EmailVerifed({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            Text(
              'Your email has been verified',
              style: screenHeadingStyle,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: FlareActor(
                "assets/animations/success.flr",
                alignment: Alignment.center,
                animation: 'success_check',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: mainColor,
                textColor: colorWhite,
                child: Text('Continue'),
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(MyHomeScreen.routename),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailNotVerified extends StatelessWidget {
  final String name;
  final String email;
  EmailNotVerified({@required this.name, @required this.email});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            child: Text(
              'An email has been sent to your registered mail id',
              style: screenHeadingStyle.copyWith(fontSize: 25),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 17),
            child: Text(
              'You have to verify your email before you can proceed. Please check your mail to verify your account',
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: MediaQuery.of(context).size.width * 0.2),
            child: LinearProgressIndicator(backgroundColor: Colors.grey[350],),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: RaisedButton(
              color: mainColor,
              textColor: colorWhite,
              child: Text('Resend verification email'),
              onPressed: () => resendVerification(email, name),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

resendVerification(String email, String name) async {
  try {
    final response = await http.post(
      URL_RESEND_VERIFICATION,
      body: {
        "email": email,
        "name": name,
      },
    );
    if (response.statusCode == 202) {
      Fluttertoast.showToast(msg: "Email sent successfully");
    } else {
      Fluttertoast.showToast(
          msg: "Seems like something\'s wrong on our end 😟");
    }
  } catch (e) {
    print(e.toString());
  }
}
