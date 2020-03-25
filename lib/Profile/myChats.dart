import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_hestia/Profile/chatScreen.dart';
import 'package:project_hestia/model/util.dart';

class MyChatsPage extends StatefulWidget {
  MyChatsPage({Key key, this.userID}) : super(key: key);
  final String userID;

  @override
  MyChatsPageState createState() => MyChatsPageState();
}

class MyChatsPageState extends State<MyChatsPage> {
  @override
  void initState() {
    super.initState();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          backgroundColor: colorWhite,
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
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 20.0, right:20.0, bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'My Chats',
                          style: TextStyle(color: colorBlack, fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          //margin: EdgeInsets.only(right: 10.0),
                          child : Icon(Icons.account_circle,color: colorBlue,  size: 40.0,)
                        )
                      ],
                    ),
                  ),
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
                  new Expanded(
                  child : ListView.builder(
                  itemCount: 2,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      margin: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20.0, left: 15.0, bottom: 20.0),
                            child : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
                                  child : Text('Name', style: TextStyle(fontSize: 17.0),),
                                ),
                                Text('Item', style: TextStyle(color: colorGrey, fontSize: 13.0))
                              ],
                            )
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext
                                  context) => ChatScreenPage()));
                            },
                            child : Container(
                              margin: EdgeInsets.only(top: 20.0, right: 15.0, bottom: 20.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: new BoxDecoration(
                                color: colorBlue,
                                shape: BoxShape.circle,
                              ),
                              child : Icon(Icons.arrow_forward_ios, color: colorWhite, size: 14.0,)
                            ),
                          )
                        ],
                      )
                    );
                  }
              )
            )      
          ]
        )
      )
    );
  }
}