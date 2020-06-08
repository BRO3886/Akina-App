import 'dart:convert';
import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/screens/home_screen.dart';
import 'package:project_hestia/screens/register.dart';
import 'package:project_hestia/model/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

class LoginScreen extends StatefulWidget {
  static const routename = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _changPassKey = GlobalKey();

  bool isLoading = false;
  bool dialogLoading = false;

  _showSnackBar(int code, String msg) {
    SnackBar snackbar;
    if (code == 200) {
      snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      );
    } else if (code == 300) {
      snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
        backgroundColor: Colors.amber[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      );
    } else {
      snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
        backgroundColor: colorRed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      );
    }
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Map<String, String> userInfo = {"email": "", "password": ""};

  _forgotPassword() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!_changPassKey.currentState.validate()) {
      return;
    }
    _changPassKey.currentState.save();
    setState(() {
      dialogLoading = true;
    });
    print(userInfo['email']);
    print("encoded");
    try {
      final response = await http.post(
        URL_RESET_PASSWORD,
        body: {
          'email': userInfo['email'],
        },
      );
      //print(response.statusCode);
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(responseBody["Status"]);
        setState(() {
          dialogLoading = false;
        });
        Navigator.of(context).pop();
        _showSnackBar(response.statusCode, responseBody["Status"]);
      } else if (response.statusCode == 404) {
        setState(() {
          dialogLoading = false;
        });
        Navigator.of(context).pop();
        _showSnackBar(response.statusCode, responseBody["Error"]);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  openDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        title: Text('Enter your email'),
        actions: <Widget>[
          (dialogLoading)
              ? LinearProgressIndicator()
              : FlatButton(
                  onPressed: _forgotPassword,
                  textColor: mainColor,
                  child: Text('OK'),
                ),
        ],
        content: Container(
          // height: 0,
          child: Form(
            key: _changPassKey,
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  gapPadding: 10,
                ),
              ),
              autocorrect: false,
              validator: (String value) {
                if (value == '') {
                  return 'This field is required';
                }
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Please enter correct email';
                }
              },
              onChanged: (email) => userInfo['email'] = email.trim(),
              onSaved: (email) => userInfo['email'] = email.trim(),
            ),
          ),
        ),
      ),
    );
  }

  _getUserDetails(String email) async {
    final uri = URL_GET_DETAILS;
    final sp = SharedPrefsCustom();
    // final body = jsonEncode({'email': email});
    try {
      final response = await http.post(uri, body: {'email': email});
      print("get details on login");
      //print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        sp.setUserName(responseBody["name"]);
        sp.setPhone(responseBody["phone"]);
        sp.setUserId(responseBody["id"]);
        sp.setShopStatus(false);
        sp.setRequestStatus(false);
      } else {
        print("get detials on login");
        //print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future _login() async {
    print('I am in login');
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(userInfo['email']);
    print(userInfo['password']);
    final body = jsonEncode(userInfo);
    print("Body of login is " + body);
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        URL_USER_VERIFY,
        body: {
          'email': userInfo['email'],
        },
      );
      print("Response of user verify is " + response.statusCode.toString());
      print(jsonDecode(response.body)['Status']);

      if (response.statusCode == 401) {
        showDialog(
          context: context,
          child: AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            actions: <Widget>[
              FlatButton(
                textColor: mainColor,
                child: Text('Understood'),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            ],
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    child: Icon(
                      Icons.cancel,
                      size: 30,
                      color: colorWhite,
                    ),
                    radius: 30,
                    backgroundColor: colorRed,
                  ),
                  Text(
                    'You need to verify your email before you can log in',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        String content = "";
        try {
          final response = await http.post(URL_USER_LOGIN, body: userInfo);
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          print("Response of login is " + responseBody.toString());
          if (responseBody.containsKey("Error")) {
            content = responseBody["Error"] +
                ". Please check your email and try again.";
          } else if (responseBody.containsKey("Status")) {
            content =
                responseBody["Status"] + ". Please enter correct password.";
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
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            );
          } else {
            if (responseBody.containsKey("Token")) {
              print("logged in successfully");
              _getUserDetails(userInfo['email']);
              final sp = SharedPrefsCustom();
              sp.setUserEmail(userInfo['email']);
              sp.setUserPassword(userInfo["password"]);
              sp.setToken(responseBody["Token"]);
              sp.setLoggedInStatus(true);
              sp.setShopStatus(false);
              sp.setRequestStatus(false);
              sp.setDeviceTokenID(deviceID);
              setState(() {
                isLoading = true;
              });
              int code = await registerDevice(responseBody["Token"]);
              print('Code from register device is '+code.toString());
              if (code == 200 || code == 201) {
                Navigator.of(context)
                    .pushReplacementNamed(MyHomeScreen.routename);
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
                    content: Text('Another account with same device credentials exist'),
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
            }
          }
        } catch (e) {
          print(e);
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
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
    print("FCM token is " + token);
    setState(() {
      deviceID = token;
    });
  }

  Map<String, String> body_register_device = {
    "user_token": "1",
    "registration_id": "123458"
  };

  Future<int> registerDevice(String tokenID) async {
    print('I am in register device of login');
    setState(() {
      isLoading = true;
    });
    print("Token id is " + tokenID);
    body_register_device['user_token'] = tokenID;
    body_register_device['registration_id'] = deviceID;

    print("Body sent to register device is " + body_register_device.toString());

    try {
      final response = await http.post(
        URL_REGISTER_DEVICE,
        // headers: {
        //   HttpHeaders.contentTypeHeader: 'application/json',
        // },
        body: body_register_device,
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Response of register device is" + responseBody.toString());
      print("Response code to register device is " + response.statusCode.toString());
      return response.statusCode;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                height: MediaQuery.of(context).size.height * 0.2,
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
                      fontSize: 55,
                      letterSpacing: 1.5,
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
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      autocorrect: false,
                      validator: (String value) {
                        if (value == '') {
                          return 'This field is required';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Please enter correct email';
                        }
                      },
                      onChanged: (email) => userInfo['email'] = email.trim(),
                      onSaved: (email) => userInfo['email'] = email.trim(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == '') {
                          return 'This field is required';
                        }
                        if (value.length < 8) {
                          return 'Password length must be atleast 8 characters long';
                        }
                      },
                      onChanged: (password) =>
                          userInfo['password'] = password.trim(),
                      onSaved: (password) =>
                          userInfo['password'] = password.trim(),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: openDialog,
                        highlightColor: Colors.blueGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                        splashColor: mainColor,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          // padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: colorGrey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        (isLoading)
                            ? Center(child: CircularProgressIndicator())
                            : RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 13.9, horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text('Login'),
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
                                onPressed: _login,
                              ),
                        /*SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05),
                          child: Row(
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
                          onPressed: () async {
                            final msg = await signInWithGoogle();
                            if (msg != '') {
                              Navigator.of(context)
                                  .pushReplacementNamed(MyHomeScreen.routename);
                            }
                          },
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
                    MaterialPageRoute(builder: (ctx) => RegsiterScreen())),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(color: mainColor),
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
