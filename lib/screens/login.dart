import 'dart:convert';
import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/screens/home_screen.dart';
import 'package:project_hestia/screens/register.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/google_auth.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

class LoginScreen extends StatefulWidget {
  static const routename = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isLoading = false;

  Map<String, String> userInfo = {"email": "", "password": ""};

  Future _login() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(userInfo['email']);
    print(userInfo['password']);
    final body = jsonEncode(userInfo);
    print(body);
    setState(() {
      isLoading = true;
    });
    String baseUrl = 'https://hestia-auth.herokuapp.com/api/user/login';
    String content = "";
    try {
      final response = await http.post(baseUrl, body: userInfo);
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      if (responseBody.containsKey("Error")) {
        content =
            responseBody["Error"] + ". Please check your email and try again.";
      } else if (responseBody.containsKey("Status")) {
        content = responseBody["Status"] + ". Please enter correct password.";
      }
      if (content != "") {
        showDialog(
          context: context,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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
          final sp = SharedPrefsCustom();
          sp.setUserEmail(userInfo['email']);
          sp.setToken(responseBody["Token"]);
          sp.setLoggedInStatus(true);
          Navigator.of(context).pushReplacementNamed(MyHomeScreen.routename);
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
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
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/hestia_logo.png",
                    height: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'HESTIA',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 40),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
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
                          borderRadius: BorderRadius.circular(10),
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
                      onChanged: (email) => userInfo['email'] = email,
                      onSaved: (email) => userInfo['email'] = email,
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
                          borderRadius: BorderRadius.circular(10),
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
                      onChanged: (password) => userInfo['password'] = password,
                      onSaved: (password) => userInfo['password'] = password,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        (isLoading)
                            ? Center(child: CircularProgressIndicator())
                            : RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: _login),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () async {
                            final msg = await signInWithGoogle();
                            if (msg != '') {
                              Navigator.of(context)
                                  .pushReplacementNamed(MyHomeScreen.routename);
                            }
                          },
                        )
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
