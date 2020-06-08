import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_hestia/model/getChats.dart';
import 'package:project_hestia/model/getViewAccepts.dart';
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/model/util.dart';
import 'package:flutter/foundation.dart';
import 'package:project_hestia/screens/chat_screen.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:http/http.dart' as http;

class OtherRequestsChatsPage extends StatefulWidget {
  OtherRequestsChatsPage({Key key, this.userID}) : super(key: key);
  final int userID;

  @override
  OtherRequestsChatsPageState createState() => OtherRequestsChatsPageState();
}

class OtherRequestsChatsPageState extends State<OtherRequestsChatsPage> {
  final int userID;
  OtherRequestsChatsPageState({this.userID});
  @override
  void initState() {
    super.initState();
    //getOtherChats();
    //getValues();
  }

  /*Future<List<String>> checkReportedList;
  List<String> reportedList;
  SharedPrefsCustom s=new SharedPrefsCustom();
  
  getValues() {
    checkReportedList = s.getReportedList();
    checkReportedList.then((resultStringLogin) {
      setState(() 60
        reportedList = resultStringLogin;
      });
      if(reportedList==null){
        setState(() {
          reportedList = [];
        });
      }
      print("Value of reported list is "+ reportedList.toString() );
    });
  }*/

  Map<String, int> data_passed = {
    'user_id': 1,
  };

  List<Chat> listOtherChats = [];

  List<Accept> listViewAccept = [];

  String snapshot = '' ;

  Future<List<Chat>> getOtherChats() async {
    //print('I am in get chats');
    final userId = await SharedPrefsCustom().getUserId();
    data_passed['user_id'] = userId;
    //

    //print("Body in other chats is " + data_passed.toString());

    var sp = SharedPrefsCustom();
    final token = await sp.getToken();
    //print(token);
    try {
      final response = await http.post(
        URL_GET_OTHER_CHATS,
        headers: {
          HttpHeaders.authorizationHeader: token,
        },
        body: json.encode(data_passed),
      );

      //print("Response of other chats is " + response.statusCode.toString());
      final data = json.decode(response.body);
      //print('Data in other chats is '+data.toString());
      if (response.statusCode == 200) {
        if(this.mounted){
          setState(() {
            listOtherChats = Chats.fromJson(data).chats;
            snapshot = 'hasData';
          });
        }
      } else {
        if(this.mounted){
          setState(() {
            snapshot = data['message'];
            listOtherChats = [];
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return listOtherChats;
  }

  @override
  Widget build(BuildContext context) {
    // return Expanded(
    //   child : bodyOtherChats()
    // );
    return FutureBuilder(
      future: getOtherChats(),
      builder: (ctx, snapshot) {
        //listOtherChats = snapshot.data;
        if (snapshot.hasData) {
          if (listOtherChats.length > 0 ) {
            return new Expanded(
                child: ListView.builder(
                    itemCount: listOtherChats.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return  listOtherChats[index].senderName == "" ? Container() :
                        //reportedList.contains(listOtherChats[index].sender.toString()) || reportedList.contains(listOtherChats[index].receiver.toString()))  ? Container() : 
                        GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) => ChatScreenPage(
                                senderID: listOtherChats[index].sender,
                                receiverID: listOtherChats[index].receiver,
                                itemName: listOtherChats[index].title,
                                personName: listOtherChats[index].senderName,
                                itemDescription: listOtherChats[index].description,
                                pagePop: true,
                                requestReceiver: listOtherChats[index].requestReceiver,
                                requestSender: listOtherChats[index].requestSender,
                                isReported: listOtherChats[index].isReported,
                              ),
                            ),
                          ).then((value){
                            if(value.toString() == 'delete'){
                              //Fluttertoast.showToast(msg: 'True that');
                              getOtherChats();
                              setState(() {
                                listOtherChats = snapshot.data;
                              });
                            }
                            // else{
                            //   Fluttertoast.showToast(msg: 'True that not');
                            // }
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            // margin: EdgeInsets.all(15),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 0.0, bottom: 10.0),
                                          child: Text(
                                            listOtherChats[index].senderName,
                                            style: TextStyle(fontSize: 17.0),
                                          ),
                                        ),
                                        Text(
                                          'Click to see more',
                                          //listOtherChats[index].title,
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
                                            builder: (BuildContext context) =>
                                                ChatScreenPage(
                                                  senderID:
                                                      listOtherChats[index]
                                                          .sender,
                                                  receiverID:
                                                      listOtherChats[index]
                                                          .receiver,
                                                  itemName:
                                                      listOtherChats[index]
                                                          .title,
                                                  personName:
                                                      listOtherChats[index]
                                                          .senderName,
                                                  itemDescription: listOtherChats[index].description,
                                                  pagePop: true,
                                                  requestReceiver: listOtherChats[index].requestReceiver,
                                                  requestSender: listOtherChats[index].requestSender,
                                                  isReported: listOtherChats[index].isReported,
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
                            )),
                      );
                    }));
          } else {
            return Text("No chats found");
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  bodyOtherChats(){
    
    if (snapshot == '') {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot == 'hasData' && listOtherChats.length == 0) {
      return Center(
        child: Text("No messages found"),
      );
    } else if (snapshot == 'hasData' && listOtherChats.length > 0) {
      return new ListView.builder(
                    itemCount: listOtherChats.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) => ChatScreenPage(
                                senderID: listOtherChats[index].sender,
                                receiverID: listOtherChats[index].receiver,
                                itemName: listOtherChats[index].title,
                                personName: listOtherChats[index].senderName,
                                itemDescription: listOtherChats[index].description,
                                pagePop: true,
                                requestReceiver: listOtherChats[index].requestReceiver,
                                requestSender: listOtherChats[index].requestSender,
                                isReported: listOtherChats[index].isReported,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                                left: 25.0,
                                right: 25.0,
                                top: 10.0,
                                bottom: 10.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 0.0, bottom: 10.0),
                                          child: Text(
                                            listOtherChats[index].senderName,
                                            style: TextStyle(fontSize: 17.0),
                                          ),
                                        ),
                                        Text(listOtherChats[index].title,
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
                                            builder: (BuildContext context) =>
                                                ChatScreenPage(
                                                  senderID:
                                                      listOtherChats[index].sender,
                                                  receiverID: listOtherChats[index]
                                                      .receiver,
                                                  itemName:
                                                      listOtherChats[index].title,
                                                  personName: listOtherChats[index]
                                                      .senderName,
                                                      itemDescription: listOtherChats[index].description,
                                                  pagePop: true,
                                                  requestReceiver: listOtherChats[index].requestReceiver,
                                                  requestSender: listOtherChats[index].requestSender,
                                                  isReported: listOtherChats[index].isReported,
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
                            )),
                      );
                    }
              );
    }
    else if(snapshot != null){
      return Container(
        child: Text(snapshot),
      );
    }
    else{
      return Container(
        child : Text('Error is from our side')
      );
    }
  }

}
