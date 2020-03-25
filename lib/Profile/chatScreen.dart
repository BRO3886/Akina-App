import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_hestia/model/util.dart';

class ChatScreenPage extends StatefulWidget {
  ChatScreenPage({Key key, this.userID}) : super(key: key);
  final String userID;

  @override
  ChatScreenPageState createState() => ChatScreenPageState();
}

class ChatScreenPageState extends State<ChatScreenPage> {
  @override
  void initState() {
    super.initState();
  }


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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Person Name',
                              style: TextStyle(color: colorBlack, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text('Item Name')
                          ],
                        ),
                        Container(
                          //margin: EdgeInsets.only(right: 10.0),
                          child : Icon(Icons.battery_alert,color: colorRed,  size: 30.0,)
                        )
                      ],
                    ),
                  ),
                  new Expanded(
                  child : ListView.builder(
                  itemCount: 2,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      margin: index==1? 
                        EdgeInsets.only(left: 15.0, right: 100.0, top: 10.0, bottom: 10.0)
                        :
                        EdgeInsets.only(left: 100.0, right: 15.0, top: 10.0, bottom: 10.0),
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                blurRadius: 3.0,
                                color: Colors.grey[600],
                                offset: Offset(0.5, 0.5))
                          ],
                          shape: BoxShape.rectangle,
                          color: index==1 ? colorWhite : colorBlue,
                          borderRadius:
                          BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
                            child : Text('Name', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: index==1 ? colorBlack : colorWhite,),),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
                            child : Text('Item', style: TextStyle(color: index==1 ? colorBlack : colorWhite, fontSize: 13.0,)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
                            child : Text('Date and Time',  style: TextStyle(color: index==1 ? colorGrey : colorWhite, fontSize: 13.0,))
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