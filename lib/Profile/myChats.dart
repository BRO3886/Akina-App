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
import 'package:project_hestia/services/accept_request.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:project_hestia/services/view_accept_request.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:http/http.dart' as http;
 

class MyChatsPage extends StatefulWidget {
  MyChatsPage({Key key, this.userID}) : super(key: key);
  final int userID;

  @override
  MyChatsPageState createState() => MyChatsPageState();
}

class MyChatsPageState extends State<MyChatsPage> {
  final int userID;
  MyChatsPageState({this.userID});
  @override
  void initState() {
    super.initState();
    //submitData();
   // _connectSocket();
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

  Map<String, int> data_passed = {
    'user_id': 1,
  };

  SocketIO socketIO;

  List<Chat> listChats=[];

  List<Accept> listViewAccept = [];

  Future<List<Chat>> getChats() async {
    data_passed['user_id'] = widget.userID;
  
    var sp = SharedPrefsCustom();
    final token = await sp.getToken();
    print(token);
    try {
      final response = await http.post(
        URL_GET_CHATS,
        headers: {
          HttpHeaders.authorizationHeader: token,
        },
        body: json.encode(data_passed),
      );

      print("Response of my chats is "+response.statusCode.toString());
      final data = json.decode(response.body);
      print('Data is '+data.toString());
      if (response.statusCode == 200) {
        setState(() {
          listChats = Chats.fromJson(data).chats;
        });
      }
      else{
        listChats = [];
      }
    } catch (e) {
      print(e.toString());
    }
    return listChats;
  }
  

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
          automaticallyImplyLeading: true,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'My Chats',
                          style: TextStyle(
                              color: colorBlack,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                            //margin: EdgeInsets.only(right: 10.0),
                            child: Icon(
                          Icons.account_circle,
                          color: mainColor,
                          size: 40.0,
                        ))
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.68,
                    padding: EdgeInsets.symmetric(vertical: 7.0),
                    decoration: new BoxDecoration(
                        color: colorWhite,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(70))),
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
                                        ? mainColor
                                        : colorWhite,
                                  ),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(70.0)),
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
                              width: 120.0,
                              padding: EdgeInsets.all(5.0),
                              decoration: new BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: pressAttentionAll
                                        ? mainColor
                                        : colorWhite,
                                  ),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(70.0)),
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
                  /*StreamBuilder(
                    stream: channel.stream,
                    builder: (context, snapshot) {
                      print("Snapshot is "+snapshot.toString());
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                      );
                    },
                  ),*/
                  /*new Expanded(
                      child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Container(
                                margin: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          blurRadius: 3.0,
                                          color: Colors.grey[600],
                                          offset: Offset(0.5, 0.5))
                                    ],
                                    shape: BoxShape.rectangle,
                                    color: colorWhite,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 20.0,
                                            left: 15.0,
                                            bottom: 20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 0.0, bottom: 10.0),
                                              child: Text(
                                                'Name',
                                                style:
                                                    TextStyle(fontSize: 17.0),
                                              ),
                                            ),
                                            Text('Item',
                                                style: TextStyle(
                                                    color: colorGrey,
                                                    fontSize: 13.0))
                                          ],
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ChatScreenPage()));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 20.0,
                                              right: 15.0,
                                              bottom: 20.0),
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
                          })),*/
                          pressAttentionMy == true ? FutureBuilder(
                            future: viewAcceptRequest(),
                            builder: (ctx, snapshot) {
                              listViewAccept = snapshot.data;
                              if (snapshot.hasData) {
                                if (listViewAccept.length > 0) {
                                  return new Expanded(
                                    child: ListView.builder(
                                        itemCount: listViewAccept.length,
                                        itemBuilder: (BuildContext ctxt, int index) {
                                          return Container(
                                              margin: EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  top: 10.0,
                                                  bottom: 10.0),
                                              decoration: BoxDecoration(
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        blurRadius: 3.0,
                                                        color: Colors.grey[600],
                                                        offset: Offset(0.5, 0.5))
                                                  ],
                                                  shape: BoxShape.rectangle,
                                                  color: colorWhite,
                                                  borderRadius:
                                                      BorderRadius.all(Radius.circular(5))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20.0,
                                                          left: 15.0,
                                                          bottom: 20.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: 0.0, bottom: 10.0),
                                                            child: Text(
                                                              listViewAccept[index].request_acceptor.toString(),
                                                              style:
                                                                  TextStyle(fontSize: 17.0),
                                                            ),
                                                          ),
                                                          Text('Item',
                                                              style: TextStyle(
                                                                  color: colorGrey,
                                                                  fontSize: 13.0))
                                                        ],
                                                      )),
                                                  GestureDetector(
                                                    onTap: () {
                                                      createChat(listViewAccept[index].request_acceptor, widget.userID.toString(), "Sample");
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 15.0,
                                                            bottom: 20.0),
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
                                        }));
                                } else {
                                  return Text("No chats found");
                                }
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ) :
                           FutureBuilder(
                            future: getChats(),
                            builder: (ctx, snapshot) {
                              listChats = snapshot.data;
                              if (snapshot.hasData) {
                                if (listChats.length > 0) {
                                  return new Expanded(
                                    child: ListView.builder(
                                        itemCount: listChats.length,
                                        itemBuilder: (BuildContext ctxt, int index) {
                                          return Container(
                                              margin: EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  top: 10.0,
                                                  bottom: 10.0),
                                              decoration: BoxDecoration(
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        blurRadius: 3.0,
                                                        color: Colors.grey[600],
                                                        offset: Offset(0.5, 0.5))
                                                  ],
                                                  shape: BoxShape.rectangle,
                                                  color: colorWhite,
                                                  borderRadius:
                                                      BorderRadius.all(Radius.circular(5))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20.0,
                                                          left: 15.0,
                                                          bottom: 20.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: 0.0, bottom: 10.0),
                                                            child: Text(
                                                              listChats[index].sender.toString(),
                                                              style:
                                                                  TextStyle(fontSize: 17.0),
                                                            ),
                                                          ),
                                                          Text('Item',
                                                              style: TextStyle(
                                                                  color: colorGrey,
                                                                  fontSize: 13.0))
                                                        ],
                                                      )),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext context) =>
                                                                      ChatScreenPage()));
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 15.0,
                                                            bottom: 20.0),
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
                                        }));
                                } else {
                                  return Text("No chats found");
                                }
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                ])));
  }

   Map<String, String> data_create_chat = {
     'receiver': "",
      'sender': "" ,
      'title': ""
  };

createChat(String r, String s, String t) async{
  data_create_chat["receiver"] = r;
  data_create_chat["sender"] = s;
  data_create_chat["title"] = t;
  try {
    final token = await SharedPrefsCustom().getToken();
    final response = await http.post(
      URL_CREATE_CHAT,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
      body: json.encode({
        'receiver': 27,
        'sender': 21 ,
        'title': "Hello"
      })
    );
    print("response is "+response.body.toString());
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder:
                  (BuildContext context) =>
                      ChatScreenPage()));
    } else {
        Fluttertoast.showToast(msg: result['message']);
    }
  } catch (e) {
    print(e.toString());
  }
}


}
