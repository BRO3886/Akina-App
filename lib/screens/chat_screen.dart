import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:project_hestia/screens/report_page.dart';
import 'package:project_hestia/model/chatMessage.dart';
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/widgets/my_back_button.dart';

class ChatScreenPage extends StatefulWidget {
  ChatScreenPage(
      {Key key,
      this.senderID,
      this.receiverID,
      @required this.requestReceiver,
      @required this.requestSender,
      @required this.itemName,
      this.personName,
      @required this.itemDescription,
      this.pagePop,
      @required this.isReported})
      : super(key: key);

  final int senderID, receiverID, requestSender, requestReceiver;
  final bool pagePop, isReported;
  final String itemName, personName, itemDescription;

  @override
  ChatScreenPageState createState() => ChatScreenPageState();
}

class ChatScreenPageState extends State<ChatScreenPage> {
  ScrollController _controller = ScrollController();
  ChatScreenPageState(
      {this.senderID,
      this.receiverID,
      this.requestReceiver,
      this.requestSender,
      this.itemName,
      this.itemDescription,
      this.pagePop,
      this.isReported});
  final int senderID, receiverID, requestSender, requestReceiver;
  final bool pagePop, isReported;
  final String itemName, itemDescription;

  @override
  void initState() {
    super.initState();
    getValues();
    showChats().then((val) => Timer(Duration(milliseconds: 500),
        () => _controller.jumpTo(_controller.position.maxScrollExtent * 1.04)));

    /*var URL = 'wss://akina.ayushpriya.tech/api/v1/ws?sender=' + widget.receiverID.toString() +'&receiver='+ (userID == widget.senderID ? widget.receiverID : widget.senderID).toString();
    print("URL is " + URL);
    channel = WebSocketChannel.connect(
      Uri.parse(URL),
    );
    channel.stream.listen((message) {
      print("I listened and the message is "+message.toString());
      setState(() {
        messages.msgs.add(json.decode(message));
      });
    });
    print("Description is "+widget.itemDescription);
    
    new Timer.periodic(new Duration(seconds: 30), (Timer t) => doSomething());*/
    if(this.mounted){
      new Timer.periodic(new Duration(seconds: 10), (Timer t) => showChats());
    }
  }

  Map<String, int> data_create_chat = {'receiver': 27, 'sender': 21};

  int userID;
  getValues() async {
    print("I am in chat screens");
    userID = await SharedPrefsCustom().getUserId();
    setState(() {
      userID;
    });

    token = await SharedPrefsCustom().getToken();
    print("Token is " + token.toString());
  }

  String token = '';

  doSomething() {
    //channel.sink.add("Hey, Satkriti here");
    print("Message sent to server");
  }

  String snapshot = '';
  List<Items> itemsList = [];
  List<String> itemNameList = [];

  Future<Messages> showChats() async {
    //print("I am in show chats");
    //final receiverID = await SharedPrefsCustom().getUserID();
    data_create_chat["receiver"] = widget.receiverID;
    data_create_chat["sender"] = widget.senderID;
    //print("Body of getting messages is " + data_create_chat.toString());
    try {
      final token = await SharedPrefsCustom().getToken();
      final response = await http.post(URL_GET_MESSAGES,
          headers: {
            HttpHeaders.authorizationHeader: token,
          },
          body: json.encode(data_create_chat));
      //print("Response in getting messages is "+response.body.toString());
      final result = json.decode(response.body);
      print("Messages are " + result.toString());
      //print("Message is "+result['message']);
      if (result['code'] == 200 && response.statusCode == 200) {
        setState(() {
          itemNameList = [];
          messages = Messages.fromJson(result);
          snapshot = 'Got Data';
          itemsList = messages.items;
          for(int i=0;i<messages.items.length;i++){
            itemNameList.add(messages.items[i].item);
          }
        });
      } else if (result['status'] == 400) {
        setState(() {
          snapshot = 'Chat blocked';
          itemsList = []; 
          itemNameList = [];
        });
      } else if (result.containsKey("message")) {
        setState(() {
          snapshot = result['message'];
          itemsList = []; 
          itemNameList = [];
        });
        Fluttertoast.showToast(msg: result['message']);
      } else {
        setState(() {
          snapshot = result['messages'];
          itemsList = []; 
          itemNameList = [];
        });
        Fluttertoast.showToast(msg: result['messages']);
      }
    } catch (e) {
      print("Error in getting messages is " + e.toString());
    }

    return messages;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    //channel.sink.close();
  }

  String text = '';
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  bool left = true;

  Messages messages;

  //WebSocketChannel channel;
  final TextEditingController controller = TextEditingController();

  ScrollController _controllerExpansion = ScrollController();

  bool expansionValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: colorWhite,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Container(
                     child : ExpansionTile(
                    children: <Widget>[
                    Container(
                     height: MediaQuery.of(context).size.height/2,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                          controller: _controllerExpansion,
                          shrinkWrap: true,
                          itemCount: itemsList.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(itemsList[index].item, style: TextStyle(color: mainColor),),
                                Text(itemsList[index].description, style: TextStyle(fontSize: 11.0),),
                                SizedBox(
                                  height: 10.0,
                                  width: 10.0,
                                )
                              ],
                            );
                          }
                        ),
                      ),
                    ],
                    title: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            widget.personName.length>10 ? widget.personName.substring(0, 9)+"..." : widget.personName,
                            style: TextStyle(
                                color: colorBlack,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        itemNameList == [] ? 
                          widget.itemName : itemNameList.toString().substring(1, itemNameList.toString().length - 1).length > 15 ?
                          itemNameList.toString().substring(1, 14)+"..." : itemNameList.toString().substring(1, itemNameList.toString().length - 1),
                        style: TextStyle(
                          color: colorBlack
                        ),
                      )
                    ),
                    leading: MyBackButton(),
                    onExpansionChanged: (bool value){
                      setState(() {
                        expansionValue = value;
                      });
                    },
                    trailing: Container(
                      child : Row(
                        mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              child: CircleAvatar(
                                child: Icon(
                                  expansionValue == true ? Icons.clear : Icons.info,
                                  size: 18,
                                  color: colorWhite,
                                ),
                                radius: 16,
                                backgroundColor: expansionValue == true ? colorRed : mainColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                deleteChatDialog();
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: colorWhite,
                                ),
                                radius: 16,
                                backgroundColor: colorRed,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ReportScreen(
                                              id: userID == widget.senderID
                                                  ? widget.receiverID
                                                  : widget.senderID,
                                              pop: widget.pagePop,
                                              requestReceiver: widget.requestReceiver,
                                              requestSender: widget.requestSender,
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: SvgPicture.asset(
                                  'assets/images/report.svg',
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        )
                      )
                    )
                  ),
                  /*Container(
                    margin: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0, bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            MyBackButton(),
                            SizedBox(
                              width: 25,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.personName,
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  itemNameList == [] ? 
                                    widget.itemName : itemNameList.toString().substring(1, itemNameList.toString().length - 1).length > 25 ?
                                    itemNameList.toString().substring(1, 24)+"..." : itemNameList.toString().substring(1, itemNameList.toString().length - 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                deleteChatDialog();
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: colorWhite,
                                ),
                                radius: 16,
                                backgroundColor: colorRed,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ReportScreen(
                                              id: userID == widget.senderID
                                                  ? widget.receiverID
                                                  : widget.senderID,
                                              pop: widget.pagePop,
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: SvgPicture.asset(
                                  'assets/images/report.svg',
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0.7,
                    child: Container(
                      // padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      // height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        // boxShadow: [
                        //   BoxShadow(
                        //     blurRadius: 5,
                        //     spreadRadius: 0,
                        //     // color: Colors.grey[600].withOpacity(0.1),
                        //     color: Color(0x23000000),
                        //   ),
                        // ],
                        // gradient: LinearGradient(
                        //     colors: [
                        //       Theme.of(context).canvasColor,
                        //       colorWhite,
                        //     ],
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                widget.itemDescription ??
                                    'No description provided',
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            (widget.itemDescription.length > 40)
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        child: AlertDialog(
                                          backgroundColor:
                                              Theme.of(context).canvasColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          titlePadding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          actions: <Widget>[
                                            FlatButton(
                                              textColor: mainColor,
                                              child: Text('Close'),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .maybePop(),
                                            )
                                          ],
                                          content: Text(
                                            widget.itemDescription,
                                            textAlign: TextAlign.center,
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.info,
                                                size: 40,
                                                color: mainColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'See More',
                                      style: TextStyle(
                                        color: colorGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                    // Icon(Icons.info, color: colorGrey,)
                                    )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),*/
                  new Expanded(
                    child: bodyMessages(),
                  ),
                  Container(
                      color: colorWhite,
                      margin: EdgeInsets.all(10.0),
                      child: Form(
                          key: _key,
                          autovalidate: _validate,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                    onTap: () {
                                      Timer(
                                          Duration(milliseconds: 300),
                                          () => _controller.jumpTo(_controller
                                              .position.maxScrollExtent));
                                    },
                                    controller: controller,
                                    // enableSuggestions: true,
                                    maxLines: 5,
                                    minLines: 1,
                                    enabled: (snapshot == 'Chat blocked' || widget.isReported) ? false : true,
                                    decoration: InputDecoration(
                                      enabled: (snapshot == 'Chat blocked' || widget.isReported) ? false : true,
                                      contentPadding: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      // fillColor: colorWhite,
                                      suffix: GestureDetector(
                                        onTap: () {
                                          sendMessage().whenComplete(() {
                                            Timer(
                                                Duration(milliseconds: 100),
                                                () => _controller.jumpTo(
                                                    _controller.position
                                                        .maxScrollExtent));
                                          });
                                        },
                                        child: Container(
                                            // margin: EdgeInsets.all(5),
                                            width: 50,
                                            // color: colorRed,
                                            child: Text(
                                              'Send',
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        gapPadding: 5,
                                      ),
                                      hintText: 'Enter message',
                                    ),
                                    validator: (val) => (val.length == 0)
                                        ? 'Please enter some text'
                                        : null,
                                    onSaved: (String val) {
                                      setState(() {
                                        text = val;
                                      });
                                    }),
                              ),
                            ],
                          )))
                ])));
  }

  bodyMessages() {
    print("Snapshot is "+snapshot);
    if (snapshot == '') {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot == 'Chat blocked') {
      return Center(child: Text('Chat is reported'));
    }
    else if (snapshot == 'Got Data' && messages.msgs.length == 0) {
      return Center(
        child: Text("No messages found"),
      );
    } else if (snapshot == 'Got Data' && messages.msgs.length > 0) {
      return ListView.builder(
          controller: _controller,
          itemCount: messages.msgs.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Stack(
              // alignment: Alignment.centerRight,
              children: <Widget>[
                (messages.msgs[index].sender.toString() == userID.toString())
                    ? Positioned(
                        right: 10,
                        top: 11.24,
                        child: Transform.rotate(
                          angle: 14.9,
                          child: Container(
                            height: 25,
                            width: 20,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        // right: (messages.msgs[index].sender.toString() ==
                        //         userID.toString())?10:0,
                        left: 10,
                        top: 11.24,
                        child: Transform.rotate(
                          angle: 14.9,
                          child: Container(
                            height: 25,
                            width: 20,
                            decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                Align(
                  alignment: (messages.msgs[index].sender.toString() !=
                          userID.toString())
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                      margin: (messages.msgs[index].sender.toString() !=
                              userID.toString())
                          ? EdgeInsets.only(
                              left: 15.0, right: 100.0, top: 10.0, bottom: 10.0)
                          : EdgeInsets.only(
                              left: 100.0,
                              right: 15.0,
                              top: 10.0,
                              bottom: 10.0),
                      padding: EdgeInsets.only(
                          top: 15.0, bottom: 0.0, left: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: (messages.msgs[index].sender.toString() !=
                                  userID.toString())
                              ? colorWhite
                              : mainColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /*Container(
                        margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
                        child : Text(messages.msgs[index].title, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: (messages.msgs[index].sender.toString() != userID.toString()) ? colorBlack : colorWhite,),),
                      ),*/
                          Container(
                            margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
                            child: Text(messages.msgs[index].title,
                                style: TextStyle(
                                  color:
                                      (messages.msgs[index].sender.toString() !=
                                              userID.toString())
                                          ? colorBlack
                                          : colorWhite,
                                  fontSize: 13.0,
                                )),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
                              child: Text(
                                  //dateFormatter(messages.msgs[index].createdAt.toLocal())
                                  dateFormatter(
                                          messages.msgs[index].createdAt) +
                                      ", " +
                                      DateFormat("hh:mm").format(messages
                                          .msgs[index].createdAt
                                          .toLocal()) +
                                      ' ${checkTimeOfDay(messages.msgs[index].createdAt)}',
                                  style: TextStyle(
                                    color: (messages.msgs[index].sender
                                                .toString() !=
                                            userID.toString())
                                        ? colorGrey
                                        : colorWhite,
                                    fontSize: 13.0,
                                  )))
                        ],
                      )),
                ),
              ],
            );
          });
    } else {
      Center(
        child: Text(snapshot.toString()),
      );
    }
  }

  var data_send_message = {'receiver': 27, 'sender': 1, 'text': "fv"};

  sendMessage() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();

      //final userID = await SharedPrefsCustom().getUserId();

      data_send_message["receiver"] =
          userID == widget.senderID ? widget.receiverID : widget.senderID;
      data_send_message["sender"] = userID;
      data_send_message["text"] = controller.text.trim();

      print("Data to create text is " + data_send_message.toString());

      //channel.sink.add(controller.text);

      Timer(Duration(milliseconds: 500),
          () => _controller.jumpTo(_controller.position.maxScrollExtent));

      controller.clear();
      print("I am here");
      final response = await http.post(URL_CREATE_MESSAGE,
          headers: {
            HttpHeaders.authorizationHeader: token,
          },
          body: json.encode(data_send_message));
      print("response of sending data is " + response.body.toString());
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Message sent");
        showChats();
      } else {
        Fluttertoast.showToast(msg: result['message']);
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  deleteChatDialog() {
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (dialogContext, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(dialogContext).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              content: Container(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        child: Icon(
                          Icons.delete,
                          size: 22,
                          color: colorWhite,
                        ),
                        radius: 18,
                        backgroundColor: colorRed,
                      ),
                      Text(
                        'Delete Chat?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: mainColor,
                            textColor: colorWhite,
                            onPressed: () {
                              deleteChat();
                              Navigator.pop(dialogContext);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Yes'),
                                SizedBox(
                                  width: 15,
                                ),
                                SvgPicture.asset("assets/images/check.svg"),
                              ],
                            ),
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: colorWhite,
                            textColor: colorBlack,
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('No'),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.clear,
                                  color: colorBlack,
                                  size: 16.0,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            );
          });
        });
  }

  var data_delete_chat = {
    "receiver": 110,
    "sender": 109,
    "who_deleted": "sender"
  };

  //I/flutter (26741): Data to delete chat is {receiver: 127, sender: 128, who_deleted: sender}

  deleteChat() async {
    data_delete_chat["receiver"] = widget.requestReceiver;
    data_delete_chat["sender"] = widget.requestSender;
    data_delete_chat["who_deleted"] =
        userID == widget.senderID ? "receiver" : "sender";

    print("Data to delete chat is " + data_delete_chat.toString());

    final client = http.Client();
    final response = await client
        .send(http.Request("DELETE", Uri.parse(URL_DELETE_CHAT))
          ..headers["Authorization"] = token
          ..body = json.encode(data_delete_chat))
        .then((value) async {
      final respStr = await value.stream.bytesToString();
      final res = json.decode(respStr);
      print("Response of delete chat is " + respStr.toString());
      print("Response code of deleting chat is " + value.statusCode.toString());
      if (res['status'] == 200 || res['code'] == 200) {
        Fluttertoast.showToast(msg: "Chat deleted successfully");
        Navigator.pop(context, 'delete');
        showChats();
      } else {
        Fluttertoast.showToast(
            msg: 'There is some problem. Please try again later!');
      }
    });
    print("Body is is " + json.encode(data_delete_chat).toString());

    /*final response = await http.delete(URL_DELETE_CHAT,
          headers: {
            HttpHeaders.authorizationHeader: token,
          },
          body: json.encode(data_send_message));*/
    //print("response of deleting chat is " + response.body.toString());
    //final result = json.decode(response.body);
  }
}
