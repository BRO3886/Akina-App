import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_hestia/model/util.dart';

class MyRequestsPage extends StatefulWidget {
  MyRequestsPage({Key key, this.userID}) : super(key: key);
  final String userID;

  @override
  MyRequestsPageState createState() => MyRequestsPageState();
}

class MyRequestsPageState extends State<MyRequestsPage> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: colorWhite,
          iconTheme: IconThemeData(
            color: colorBlack
          ),
         // title: Text(
            //'Profile',
           // style: TextStyle(color: colorBlack, fontSize: 24.0),
          //),
          // actions: <Widget>[
          //   Container(
          //     margin: EdgeInsets.only(right: 20.0),
          //     child : Icon(Icons.account_circle,color: colorBlue,)
          //   )
          // ],
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
                          'My Requests',
                          style: TextStyle(color: colorBlack, fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          //margin: EdgeInsets.only(right: 10.0),
                          child : Icon(Icons.account_circle,color: colorBlue,  size: 40.0,)
                        )
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
                                  child : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Name', style: TextStyle(fontSize: 17.0),),
                                      Container(
                                        margin: EdgeInsets.only(left: 18.0),
                                        child: Text('4', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),)
                                      )
                                    ],
                                  ),
                                ),
                                Text('Date and Time', style: TextStyle(color: colorGrey, fontSize: 13.0))
                              ],
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.0, right: 15.0, bottom: 20.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: new BoxDecoration(
                              color: colorRed,
                              shape: BoxShape.circle,
                            ),
                            child : Icon(Icons.delete, color: colorWhite, size: 14.0,)
                          ),
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