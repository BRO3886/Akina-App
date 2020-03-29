import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

Future<Map<String, String>> getUserDetails() async {
  final sp = SharedPrefsCustom();
  final name = await sp.getUserName();
  final email = await sp.getUserEmail();
  final phone = await sp.getPhone();
  final userDetails = {
    'name': '',
    'email': '',
    'phone': '',
  };
  userDetails['name'] = name ?? '';
  userDetails['email'] = email ?? '';
  userDetails['phone'] = phone ?? '';
  return userDetails;
}

class EditProfileScreen extends StatefulWidget {
  static const routename = "/edit-profile";
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController nameController = TextEditingController();
  // TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  _showSnackBar(int code, String msg) {
    SnackBar snackbar;
    if (code == 200) {
      snackbar = SnackBar(
        content: Text(msg),
        backgroundColor: Colors.teal,
      );
    } else if (code == 300) {
      snackbar = SnackBar(
        content: Text(msg),
        backgroundColor: Colors.amber[900],
      );
    } else {
      snackbar = SnackBar(
        content: Text(msg),
        backgroundColor: colorRed,
      );
    }
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Map<String, String> newuserDetails = {
    'name': '',
    'email': '',
    'phone': '',
  };

  submitData() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(newuserDetails);
    final body = jsonEncode(newuserDetails);
    print(body);
    setState(() {
      isLoading = true;
    });
    //TODO: --better practice-- remove later and proivde config file
    String uri = 'https://hestia-auth.herokuapp.com/api/user/updateUser';
    var sp = SharedPrefsCustom();
    final token = await sp.getToken();
    try {
      final response = await http.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'token': token,
        },
        body: body,
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      if (response.statusCode == 200) {
        if (responseBody.containsKey("Status")) {
          _showSnackBar(200, responseBody["Status"]);
        } else if (responseBody.containsKey("Email")) {
          _showSnackBar(300, responseBody["Email"]);
        }
        sp.setUserName(newuserDetails['name']);
        sp.setUserEmail(newuserDetails['email']);
        sp.setPhone(newuserDetails["phone"]);
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  _changePassword() async {
    final sp = SharedPrefsCustom();
    final email = await sp.getUserEmail();
    //TODO: --better practice-- remove later and proivde config file
    String uri = 'https://hestia-auth.herokuapp.com/api/user/forgotPassword';
    Map<String, String> bodyText = {
      'email': email,
    };
    final body = jsonEncode(bodyText);
    try {
      final response = await http.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader:'application/json',
        },
        body: body,
      );
      if(response.statusCode == 200){
        Map<String,dynamic> responseBody = jsonDecode(response.body);
        if(responseBody.containsKey("Status")){
          _showSnackBar(200,responseBody["Status"]);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
      ),
      body: FutureBuilder(
        future: getUserDetails(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            final Map<String, String> userDetails = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Edit Profile',
                      style: screenHeadingStyle,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: userDetails['name'],
                            // controller: nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                gapPadding: 10,
                              ),
                            ),
                            // onChanged: (value) => userInfo["name"] = value,
                            onSaved: (value) => newuserDetails["name"] = value,
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
                            initialValue: userDetails['email'],
                            // controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                gapPadding: 10,
                              ),
                            ),
                            // onChanged: (value) => userInfo["name"] = value,
                            onSaved: (value) => newuserDetails["email"] = value,
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
                            initialValue: userDetails['phone'],
                            // controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                gapPadding: 10,
                              ),
                            ),
                            // onChanged: (value) => userInfo["name"] = value,
                            onSaved: (value) => newuserDetails["phone"] = value,
                            validator: (value) {
                              if (value == "") {
                                return "This field is required";
                              }
                              if (value.length != 10) {
                                return "Enter a valid phone number";
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        (isLoading)
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                color: mainColor,
                                textColor: colorWhite,
                                onPressed: submitData,
                                child: Text('Submit'),
                              ),
                        SizedBox(
                          width: 15,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: colorWhite,
                          textColor: mainColor,
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(),
                    FlatButton(
                      child: Text('Change Password'),
                      textColor: mainColor,
                      onPressed: _changePassword,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Edit Profile',
                    style: screenHeadingStyle,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
