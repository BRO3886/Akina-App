import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_hestia/Profile/reportPage.dart';
import 'package:project_hestia/model/chatMessage.dart';
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/widgets/my_back_button.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreenPage extends StatefulWidget {
  ChatScreenPage(
      {Key key,
      this.senderID,
      this.receiverID,
      @required this.itemName,
      this.personName,
      @required this.itemDescription,
      this.pop})
      : super(key: key);

  final int senderID, receiverID;
  final bool pop;
  final String itemName, personName, itemDescription;

  @override
  ChatScreenPageState createState() => ChatScreenPageState();
}

class ChatScreenPageState extends State<ChatScreenPage> {
  ScrollController _controller = ScrollController();
  ChatScreenPageState(
      {this.senderID, this.receiverID, this.itemName, this.itemDescription, this.pop});
  final int senderID, receiverID;
  final bool pop;
  final String itemName, itemDescription;

  @override
  void initState() {
    super.initState();
    getValues();
    showChats();

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
    new Timer.periodic(new Duration(seconds: 10), (Timer t) => showChats());
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
  }

  String token = '';

  doSomething() {
    //channel.sink.add("Hey, Satkriti here");
    print("Message sent to server");
  }

  String snapshot = '';

  Future<Messages> showChats() async {
    print("I am in show chats");
    //final receiverID = await SharedPrefsCustom().getUserID();
    data_create_chat["receiver"] = widget.receiverID;
    data_create_chat["sender"] = widget.senderID;
    print("Body of getting messages is " + data_create_chat.toString());
    try {
      final token = await SharedPrefsCustom().getToken();
      final response = await http.post(URL_GET_MESSAGES,
          headers: {
            HttpHeaders.authorizationHeader: token,
          },
          body: json.encode(data_create_chat));
      //print("Response in getting messages is "+response.body.toString());
      final result = json.decode(response.body);
      //print("Messgaes are " + result.toString());
      if (response.statusCode == 200) {
        setState(() {
          messages = Messages.fromJson(result);
          snapshot = 'Got Data';
        });
      } else {
        setState(() {
          snapshot = result['message'];
        });
        Fluttertoast.showToast(msg: result['message']);
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
                                Text(widget.itemName),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ReportScreen(
                                          id: widget.receiverID,
                                          pop: widget.pop,
                                        )));
                          },
                          child: Container(
                            //margin: EdgeInsets.only(right: 10.0),
                            child: SvgPicture.asset(
                              'assets/images/report.svg',
                              width: 30,
                            ),
                          ),
                        ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              (widget.itemDescription),
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).canvasColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                            Navigator.of(context).maybePop(),
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
                                          size: 30,
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
                        ],
                      ),
                    ),
                  ),
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
                                    decoration: InputDecoration(
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
    if (snapshot == '') {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot == 'Got Data' && messages.msgs.length == 0) {
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
                                      ',  ${messages.msgs[index].createdAt.toLocal().hour}:${messages.msgs[index].createdAt.toLocal().minute}',
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
        child: Text(snapshot),
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
      data_send_message["text"] = controller.text;

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
}
