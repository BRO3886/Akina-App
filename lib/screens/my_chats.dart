import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_hestia/model/util.dart';
import 'package:flutter/foundation.dart';
import 'package:project_hestia/screens/my_chat_requests.dart';
import 'package:project_hestia/screens/other_chat_requests.dart';
import 'package:project_hestia/screens/show_shop_suggestios.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:project_hestia/widgets/my_back_button.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';

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


  @override
  void dispose() {
    super.dispose();
  }

  SocketIO socketIO;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: 
        /*CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      //height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  MySliverAppBar(
                    title: 'Chats and Suggestions',
                    isReplaced: false,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      //height: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ),
                  SliverFillRemaining(
                    child :  Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ShopSuggestionsScreen()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 17),
                      //width: MediaQuery.of(context).size.width * 0.75,
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
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "assets/images/suggestions.svg",
                          color: mainColor,
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: new BoxDecoration(
                            color: mainColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: colorWhite,
                            size: 14.0,
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.only(top: 2, left: 14, right: 14),
                        title: Text(
                          'Suggestions',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.68,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                                'Others Requests',
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
                  SizedBox(
                    height: 18,
                  ),
                  pressAttentionMy == true
                      ? MyRequestsChatsPage(
                          userID: userID,
                        )
                      : OtherRequestsChatsPage(
                          userID: userID,
                        )
                ]))
                  ),
                ],
              )*/
              
            Container(
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
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: screenHeadingStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.06),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ShopSuggestionsScreen()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 17),
                      //width: MediaQuery.of(context).size.width * 0.75,
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
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "assets/images/suggestions.svg",
                          color: mainColor,
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: new BoxDecoration(
                            color: mainColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: colorWhite,
                            size: 14.0,
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.only(top: 2, left: 14, right: 14),
                        title: Text(
                          'Suggestions',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.68,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                                'Others Requests',
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
                  SizedBox(
                    height: 18,
                  ),
                  pressAttentionMy == true
                      ? MyRequestsChatsPage(
                          userID: userID,
                        )
                      : OtherRequestsChatsPage(
                          userID: userID,
                        )
                ]))
                );
  }
}
