import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_hestia/Profile/My%20Chats/myChatRequests.dart';
import 'package:project_hestia/Profile/My%20Chats/otherChatRequests.dart';
import 'package:project_hestia/Profile/chatScreen.dart';
import 'package:project_hestia/model/getChats.dart';
import 'package:project_hestia/model/getViewAccepts.dart';
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/model/util.dart';
import 'package:flutter/foundation.dart';
import 'package:project_hestia/services/accept_request.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:project_hestia/services/view_accept_request.dart';
import 'package:project_hestia/widgets/my_back_button.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:http/http.dart' as http;

class MyChatsPage extends StatefulWidget {
  MyChatsPage({Key key}) : super(key: key);

  @override
  MyChatsPageState createState() => MyChatsPageState();
}

class MyChatsPageState extends State<MyChatsPage> {
  @override
  void initState() {
    super.initState();
    getValues();
    //submitData();
    // _connectSocket();
  }

  int userID;

  getValues() async {
    userID = await SharedPrefsCustom().getUserId();
    setState(() {
      userID;
    });
  }

  void AllAction() {
    setState(() {
      pressAttentionAll = true;
      pressAttentionAllText = true;
      pressAttentionMy = false;
      pressAttentionMyText = false;
    });
  }

  void MyAction() {
    setState(() {
      pressAttentionAllText = false;
      pressAttentionMy = true;
      pressAttentionMyText = true;
      pressAttentionAll = false;
    });
  }

  bool pressAttentionAll = false;
  bool pressAttentionMy = true;
  bool pressAttentionAllText = false;
  bool pressAttentionMyText = true;

  //WebSocketChannel channel = IOWebSocketChannel.connect('ws://hestia-chat.herokuapp.com/api/v1/getChats/21',);

  @override
  void dispose() {
    //channel.sink.close();
    super.dispose();
  }

  SocketIO socketIO;

  /*_connectSocket() { 
    //update your domain before using  
    socketIO = SocketIOManager().createSocketIO("ws://hestia-chat.herokuapp.com/api/v1", "/getChats/21", query: data.toString(), socketStatusCallback: _socketStatus); 

    //call init socket before doing anything 
    socketIO.init(); 

    //subscribe event
    socketIO.subscribe("socket_info", _onSocketInfo(data)); 

    //connect socket 
    socketIO.connect(); 
   }

  _socketStatus(dynamic data) { 
    print("Socket status: " + data.toString()); 
  }
   _onSocketInfo(dynamic data) {
    print("Socket info: " + data.toString());
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: colorWhite,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Theme.of(context).canvasColor,
          /*title: Transform(
              transform:  Matrix4.translationValues(0.0, 0.0, 0.0),
              child: Text(
                'My Chats',
                style: TextStyle(color: colorBlack, fontSize: 30.0, fontWeight: FontWeight.bold),
              ),   
          ),          
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child : Icon(Icons.account_circle,color: colorBlue,  size: 40.0,)
            )
          ],
           bottom: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: Container(
                  color: colorWhite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        decoration: new BoxDecoration(
                            color: colorWhite,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(70))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                MyAction();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 120.0,
                                  padding: EdgeInsets.all(5.0),
                                  decoration: new BoxDecoration(
                                      border: Border.all(
                                        width: 1.0,
                                        color: pressAttentionMy
                                            ? colorBlue
                                            : colorWhite,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(70.0)),
                                      color:
                                          pressAttentionMy ? colorBlue : colorWhite),
                                  child: Text(
                                    'My Requests',
                                    style: TextStyle(
                                        color: pressAttentionMyText
                                            ? colorWhite
                                            : colorBlack,
                                        fontSize: 13.0),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                AllAction();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 120.0,
                                  padding: EdgeInsets.all(5.0),
                                  decoration: new BoxDecoration(
                                      border: Border.all(
                                        width: 1.0,
                                        color:
                                            pressAttentionAll ? colorBlue : colorWhite,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(70.0)),
                                      color:
                                          pressAttentionAll ? colorBlue : colorWhite),
                                  child: Text(
                                    'All Requests',
                                    style: TextStyle(
                                        color: pressAttentionAllText
                                            ? colorWhite
                                            : colorBlack,
                                        fontSize: 13.0),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),*/
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0, bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MyBackButton(),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Chats and Suggestions',
                          overflow: TextOverflow.ellipsis,
                          style: screenHeadingStyle.copyWith(fontSize: 25),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.68,
                    // padding: EdgeInsets.symmetric(vertical: 7.0),
                    decoration: new BoxDecoration(
                        color: colorWhite,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            MyAction();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.34,
                              padding: EdgeInsets.all(5.0),
                              decoration: new BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: pressAttentionMy
                                        ? mainColor
                                        : colorWhite,
                                  ),
                                  borderRadius:
                                      new BorderRadius.all(Radius.circular(5)),
                                  color: pressAttentionMy
                                      ? mainColor
                                      : colorWhite),
                              child: Text(
                                'My Requests',
                                style: TextStyle(
                                    color: pressAttentionMyText
                                        ? colorWhite
                                        : colorBlack,
                                    fontSize: 13.0),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            AllAction();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.34,
                              padding: EdgeInsets.all(5.0),
                              decoration: new BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: pressAttentionAll
                                        ? mainColor
                                        : colorWhite,
                                  ),
                                  borderRadius:
                                      new BorderRadius.all(Radius.circular(5)),
                                  color: pressAttentionAll
                                      ? mainColor
                                      : colorWhite),
                              child: Text(
                                'All Requests',
                                style: TextStyle(
                                    color: pressAttentionAllText
                                        ? colorWhite
                                        : colorBlack,
                                    fontSize: 13.0),
                              )),
                        ),
                      ],
                    ),
                  ),
                  pressAttentionMy == true
                      ? MyRequestsChatsPage(
                          userID: userID,
                        )
                      : OtherRequestsChatsPage(
                          userID: userID,
                        )
                ])));
  }
}
