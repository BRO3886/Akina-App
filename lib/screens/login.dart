import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:project_hestia/screens/register.dart';
import 'package:project_hestia/utils.dart';

class LoginScreen extends StatelessWidget {
  static const routename = "/login";
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
                  Icon(Icons.account_circle),
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
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 10,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 10,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          onPressed: () {},
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 30),
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
                          onPressed: () {},
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
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => RegsiterScreen())),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(color: mainColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
