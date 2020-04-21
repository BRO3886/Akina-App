import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/edit_profile.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/screens/my_chats.dart';
import 'package:project_hestia/screens/my_requests.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:project_hestia/services/view_my_requests.dart';
import 'package:project_hestia/widgets/my_back_button.dart';

resetVariables() async {
  final sp = SharedPrefsCustom();
  // bool gauthUsed = await sp.getIfUsedGauth();
  // if (gauthUsed != null) {
  //   if (gauthUsed) {
  //     signOutGoogle();
  //   }
  // }
  sp.setLoggedInStatus(false);
  // sp.setIfUsedGauth(false);
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).canvasColor,
          iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
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
                          top: 10.0, left: 14.9, right: 20.0, bottom: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: MyBackButton(),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                                color: colorBlack,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(EditProfileScreen.routename),
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
                                ),
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
                                child: Text('Edit Profile'),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushNamed(EditProfileScreen.routename),
                                child: Container(
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
                              ),
                            ],
                          )),
                    ),
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
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: 15,
                                      color: Colors.grey[200],
                                      width: 1,
                                    ),
                                    FutureBuilder(
                                      future: getMyRequests(),
                                      builder: (ctx, snapshot) {
                                        if (snapshot.hasData) {
                                          AllRequests allRequests =
                                              snapshot.data;
                                          return Text(
                                            allRequests.request.length
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          );
                                        } else {
                                          return Text('...');
                                        }
                                      },
                                    ),
                                  ],
                                ),
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
                    ),
                    GestureDetector(
                      onTap: () async {
                        final userId = await SharedPrefsCustom().getUserId();
                        print("User id while creating is " + userId.toString());
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) => MyChatsPage(
                                    //userID: userId,
                                    )));
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
                                      Text('Chats and Suggestions'),
                                      Container(
                                          margin: EdgeInsets.only(left: 18.0),
                                          child: Text(
                                            '',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17.0, vertical: 10),
                      child: Divider(),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(right: 8.0, bottom: 20.0, left: 8),
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        textColor: colorWhite,
                        color: colorRed,
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text('Logout'),
                        ),
                        onPressed: () {
                          resetVariables();
                          Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routename, (route)=>false);
                        },
                      ),
                    )
                  ])),
        ));
  }
}
