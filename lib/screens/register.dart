import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_hestia/model/global.dart';
import 'package:ant_icons/ant_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_hestia/screens/email_verification.dart';
import 'package:project_hestia/screens/home_screen.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

class RegsiterScreen extends StatefulWidget {
  static const routename = "/register";

  @override
  _RegsiterScreenState createState() => _RegsiterScreenState();
}

class _RegsiterScreenState extends State<RegsiterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
    setState(() {
      isLoading = true;
    });
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pushReplacementNamed(MyHomeScreen.routename);
      }
      else{
        sp.setLoggedInStatus(false);
        showDialog(
          context: context,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text('Error'),
            content: Text(responseBody['message'].toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                textColor: mainColor,
                onPressed: () => Navigator.of(context).maybePop(),
              )
            ],
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isLoading = false;

  Map<String, String> userInfo = {
    "email": "",
    "password": "",
    "name": "",
    "phone": ""
  };

  final sp = SharedPrefsCustom();

  Future _register() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    final body = jsonEncode(userInfo);
    print(body);
    setState(() {
      isLoading = true;
    });
    //String baseUrl = 'https://hestia-auth.herokuapp.com/api/user/register';
    String content = "";
    try {
      final response = await http.post(URL_USER_REGISTER, body: userInfo);
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      if (responseBody.containsKey("Error")) {
        content = responseBody["Error"];
      } else if (responseBody.containsKey("Verify")) {
        //content = responseBody["Verify"];
        // Fluttertoast.showToast(
        //     msg: 'An email has been sent to your registered mail ID');
        sp.setUserPassword(userInfo['password']);
        Navigator.of(context).pushReplacementNamed(EmailVerificationPage.routename, arguments: userInfo);
      } else if (responseBody.containsKey("Token")) {
        print("registered succesfully and password is "+userInfo["password"]);
        try {
          //String loginUrl = 'https://hestia-auth.herokuapp.com/api/user/login';
          // String email = userInfo["email"];
          // String password = userInfo["password"];
          // // final loginInfo = {"email": email, "password": password};
          // final loginResponse = await http.post(URL_USER_LOGIN, body: loginInfo);
          // Map<String, dynamic> loginBody = jsonDecode(loginResponse.body);
          sp.setUserEmail(userInfo["email"]);
          sp.setUserPassword(userInfo["password"]);
          sp.setUserName(userInfo["name"]);
          sp.setPhone(userInfo["phone"]);
          sp.setToken(responseBody["Token"]);
          sp.setDeviceTokenID(deviceID);
          Navigator.of(context).maybePop();
          registerDevice(responseBody["Token"]);
        } catch (e) {
          print(e);
        }
      }
      if (content != "") {
        showDialog(
          context: context,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text('Error'),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                textColor: mainColor,
                onPressed: () => Navigator.of(context).maybePop(),
              )
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    "assets/images/hestia_logo.png",
                    height: 50,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                  Text(
                    'AKINA',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 55,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      onChanged: (value) => userInfo["name"] = value.trim(),
                      onSaved: (value) => userInfo["name"] = value.trim(),
                      validator: (value) {
                        if (value == "") {
                          return "This field is required";
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      onChanged: (value) => userInfo["phone"] = value.trim(),
                      onSaved: (value) => userInfo["phone"] = value.trim(),
                      validator: (value) {
                        if (value == "") {
                          return "This field is required";
                        }
                        if (value.length != 10) {
                          return "Enter a valid phone number";
                        }
                        if(value.contains(" ")){
                          return "Can\'t contain spaces";
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      onChanged: (value) => userInfo["email"] = value.trim(),
                      onSaved: (value) => userInfo["email"] = value.trim(),
                      validator: (value) {
                        if (value == "") {
                          return "This field is required";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Please enter correct email';
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      onChanged: (value) => userInfo["password"] = value.trim(),
                      onSaved: (value) => userInfo["password"] = value.trim(),
                      validator: (value) {
                        if (value == "") {
                          return "This field is required";
                        }
                        if (value.length < 8) {
                          return "Password length must be atleast 8 characters long";
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        (isLoading)
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical: 13.9),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text('Register'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      AntIcons.right_outline,
                                      size: 16,
                                    )
                                  ],
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onPressed: _register,
                              ),
                        /*SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                              vertical: 14),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Sign in with',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                AntIcons.google,
                                size: 20,
                                color: Colors.grey[700],
                              )
                            ],
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () {},
                        )*/
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => LoginScreen())),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: mainColor),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
