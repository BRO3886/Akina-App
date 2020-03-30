import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_hestia/Profile/chatScreen.dart';
import 'package:project_hestia/model/getChats.dart';
import 'package:project_hestia/model/getViewAccepts.dart';
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/model/util.dart';
import 'package:flutter/foundation.dart';
import 'package:project_hestia/screens/show_shop_suggestios.dart';
import 'package:project_hestia/services/accept_request.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:project_hestia/services/view_accept_request.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:http/http.dart' as http;

class MyRequestsChatsPage extends StatefulWidget {
  MyRequestsChatsPage({Key key, this.userID}) : super(key: key);
  final int userID;

  @override
  MyRequestsChatsPageState createState() => MyRequestsChatsPageState();
}

class MyRequestsChatsPageState extends State<MyRequestsChatsPage> {
  final int userID;
  MyRequestsChatsPageState({this.userID});
  @override
  void initState() {
    super.initState();
  }

  Map<String, int> data_passed = {
    'user_id': 1,
  };

  SocketIO socketIO;

  List<Chat> listMyChats = [];

  Future<List<Chat>> getMyChats() async {
    data_passed['user_id'] = widget.userID;
    //print("Body in my chats is "+data_passed.toString());
    var sp = SharedPrefsCustom();
    final token = await sp.getToken();
    print(token);
    try {
      final response = await http.post(
        URL_GET_MY_CHATS,
        headers: {
          HttpHeaders.authorizationHeader: token,
        },
        body: json.encode(data_passed),
      );

      //print("Response of my chats is "+response.statusCode.toString());
      final data = json.decode(response.body);
      //print('Data in my chats is '+data.toString());
      if (response.statusCode == 200) {
        setState(() {
          listMyChats = Chats.fromJson(data).chats;
        });
      } else {
        setState(() {
          listMyChats = [];
        });
      }
    } catch (e) {
      print(e.toString());
    }
    return listMyChats;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(children: <Widget>[
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => ShopSuggestionsScreen()));
        },
        child: Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 0,
                color: Color(0x23000000),
              ),
            ],
          ),
          child: Text(
            'Suggestions',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      FutureBuilder(
        future: getMyChats(),
        builder: (ctx, snapshot) {
          listMyChats = snapshot.data;
          if (snapshot.hasData) {
            if (listMyChats.length > 0) {
              return new Expanded(
                child: ListView.builder(
                    itemCount: listMyChats.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                          margin: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  color: Color(0x23000000),
                                ),
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 0.0, bottom: 10.0),
                                        child: Text(
                                          listMyChats[index].sender.toString(),
                                          style: TextStyle(fontSize: 17.0),
                                        ),
                                      ),
                                      Text('Item',
                                          style: TextStyle(
                                              color: colorGrey, fontSize: 13.0))
                                    ],
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ChatScreenPage(
                                                senderID:
                                                    listMyChats[index].sender,
                                                receiverID:
                                                    listMyChats[index].receiver,
                                              )));
                                },
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
                              )
                            ],
                          ));
                    }),
              );
            } else {
              return Text("No chats found");
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      )
    ]));
  }

  Map<String, String> data_create_chat = {
    'receiver': "",
    'sender': "",
    'title': ""
  };

  createChat(String r, String s, String t) async {
    data_create_chat["receiver"] = r;
    data_create_chat["sender"] = s;
    data_create_chat["title"] = t;
    try {
      final token = await SharedPrefsCustom().getToken();
      final response = await http.post(URL_CREATE_CHAT,
          headers: {
            HttpHeaders.authorizationHeader: token,
          },
          body: json.encode({'receiver': 27, 'sender': 21, 'title': "Hello"}));
      //print("response is "+response.body.toString());
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => ChatScreenPage()));
      } else {
        Fluttertoast.showToast(msg: result['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
