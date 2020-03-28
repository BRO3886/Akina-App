import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_hestia/Profile/myChats.dart';
import 'package:project_hestia/Profile/myRequests.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/services/google_auth.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

class ProfilePage extends StatefulWidget {
  static const routename = "/profile";
  ProfilePage({Key key, this.userID}) : super(key: key);
  final String userID;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  resetVariables() async {
    final sp = SharedPrefsCustom();
    bool gauthUsed = await sp.getIfUsedGauth();
    if (gauthUsed != null) {
      if (gauthUsed) {
        signOutGoogle();
      }
    }
    sp.setLoggedInStatus(false);
    sp.setIfUsedGauth(false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Theme.of(context).canvasColor,
          iconTheme: IconThemeData(color: Colors.black),
          // title: Text(
          //'Profile',
          // style: TextStyle(color: colorBlack, fontSize: 24.0),
          //),
          // actions: <Widget>[
          //   Container(
          //     margin: EdgeInsets.only(right: 20.0),
          //     child : Icon(Icons.account_circle,color: mainColor,)
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0, bottom: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Profile',
                            style: TextStyle(
                                color: colorBlack,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Hero(
                            tag: 'profile',
                            child: Container(
                                //margin: EdgeInsets.only(right: 10.0),
                                child: Icon(
                              Icons.account_circle,
                              color: mainColor,
                              size: 40.0,
                            )),
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 0,
                                // color: Colors.grey[600].withOpacity(0.1),
                                color: Color(0x23000000),
                              ),
                              // BoxShadow(
                              //     blurRadius: 3.0,
                              //     color: Colors.grey[600],
                              //     offset: Offset(0.5, 0.5))
                            ],
                            shape: BoxShape.rectangle,
                            color: colorWhite,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  top: 20.0, left: 15.0, bottom: 20.0),
                              child: Text('Edit Profile'),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: 20.0, right: 15.0, bottom: 20.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: new BoxDecoration(
                                  color: mainColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: colorWhite,
                                  size: 14.0,
                                )),
                          ],
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MyRequestsPage()));
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  // color: Colors.grey[600].withOpacity(0.1),
                                  color: Color(0x23000000),
                                )
                                // BoxShadow(
                                //     blurRadius: 3.0,
                                //     color: Colors.grey[600],
                                //     offset: Offset(0.5, 0.5))
                              ],
                              shape: BoxShape.rectangle,
                              color: colorWhite,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 20.0, left: 15.0, bottom: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text('My Requests'),
                                      Container(
                                          margin: EdgeInsets.only(left: 18.0),
                                          child: Text(
                                            '4',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 20.0, right: 15.0, bottom: 20.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: new BoxDecoration(
                                    color: mainColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: colorWhite,
                                    size: 14.0,
                                  )),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MyChatsPage()));
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  // color: Colors.grey[600].withOpacity(0.1),
                                  color: Color(0x23000000),
                                )
                                // BoxShadow(
                                //     blurRadius: 3.0,
                                //     color: Colors.grey[600],
                                //     offset: Offset(0.5, 0.5))
                              ],
                              shape: BoxShape.rectangle,
                              color: colorWhite,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 20.0, left: 15.0, bottom: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text('My Chats'),
                                      Container(
                                          margin: EdgeInsets.only(left: 18.0),
                                          child: Text(
                                            '4',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 20.0, right: 15.0, bottom: 20.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: new BoxDecoration(
                                    color: mainColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: colorWhite,
                                    size: 14.0,
                                  )),
                            ],
                          )),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 20.0, right: 8.0, bottom: 20.0, left: 8),
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        textColor: colorWhite,
                        color: mainColor,
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text('Logout'),
                        ),
                        onPressed: () {
                          resetVariables();
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routename);
                        },
                      ),
                    )
                  ])),
        ));
  }
}
