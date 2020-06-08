import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_hestia/screens/chat_screen.dart';
import 'package:project_hestia/model/global.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/services/shared_prefs_custom.dart';
import '../model/request.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> acceptRequest(BuildContext context, String itemID, String itemNameInitial, String receiverID, String description) async {
  bool returnBool;
  Position position;
  PermissionStatus permissionStatus =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
  if (permissionStatus != PermissionStatus.granted) {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
    if (permissions[PermissionGroup.location] != PermissionStatus.granted) {
      Fluttertoast.showToast(msg: 'Required Permissions Not Granted');
      /*return AllRequests(
          message: 'Required Permissions Not Granted', request: []);*/
      returnBool =  false;
    }
  }
  try {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.unknown) {
      position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
    }
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    final address = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(position.latitude, position.longitude));
    print(address.first.locality);
    final token = await SharedPrefsCustom().getToken();
    final senderID = await SharedPrefsCustom().getUserId();
    
    final response = await http.post(
      URL_ACCEPT_REQUEST,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
      body: {
        'request_id':itemID.toString(),
        //'location': 'Noida'
        'location': address.first.locality
        //TODO: change location address.first.locality
      }
    );
    print("response is "+response.body.toString());
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      returnBool =  await createChat(context, senderID, receiverID, itemNameInitial, description);
      //Fluttertoast.showToast(msg: 'Request accepted!');

      //I/flutter ( 6821): response is {"message":"Item Already Accepted"}
    } else if(result['message'].toString().contains('blocked')){
      Fluttertoast.showToast(msg: 'You cannot accept this request');
      returnBool =  false;
    }
    else {
      Fluttertoast.showToast(msg: result['message']);
      returnBool =  false;
    }
  } catch (e) {
    print(e.toString());
    returnBool =  false;
  }
  return returnBool;
}

var bodyCreateChatRoom = {
    'receiver' : 1,
    'sender': 'sender',
    'title': 'itemName',
    "request_sender": 1,
    "request_receiver": 'sender',
    'req_desc' : 'description'
  };

Future<bool> createChat(BuildContext context, int sender, String receiver, String itemNameInitial, String description) async{ 
  bool returnBool; 
  print("I am in create chat");
  try {
    bodyCreateChatRoom['receiver'] = int.parse(receiver);
    bodyCreateChatRoom['sender'] = sender ;
    bodyCreateChatRoom['title'] = itemNameInitial;
    bodyCreateChatRoom["request_sender"] = int.parse(receiver);
	  bodyCreateChatRoom["request_receiver"] = sender;
    bodyCreateChatRoom['req_desc'] = description;
    final token = await SharedPrefsCustom().getToken();
    final response = await http.post(
      URL_CREATE_CHAT,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
      body: json.encode(
        bodyCreateChatRoom
        /*{
        'receiver': int.parse(receiver),
        'sender': sender ,
        'title': itemName,
        "request_sender": int.parse(receiver),
	      "request_receiver": sender,
        'req_desc' : description
      }*/)
    );

    print("Body of create chat is " + bodyCreateChatRoom.toString() );
    print("response is "+response.body.toString());
    final result = json.decode(response.body);
    print("Result of create chat room is "+result.toString());
    if (result["code"] == 200) {
      Fluttertoast.showToast(msg: 'Request accepted!');
      print("Result from create chat room is "+result.toString());
      print("Description is "+description +" "+sender.toString()+" "+int.parse(receiver).toString()+" "+itemNameInitial+" "+result['chat_room']['sender_name'].toString());
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                ChatScreenPage(
                  senderID: sender,
                  receiverID: int.parse(receiver),
                  itemName: itemNameInitial,
                  personName: result['chat_room']['sender_name'],
                  itemDescription: description,
                  pagePop: false,
                  requestReceiver: result['chat_room']['request_receiver'],
                  requestSender: result['chat_room']['request_sender'],
                  isReported: false,
        )));
      returnBool =  false;
    } else if(result["code"] == 500 || result["status"] == 500){
      Fluttertoast.showToast(msg: 'Chat room is already created ');
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                ChatScreenPage(
                  senderID: sender,
                  receiverID: int.parse(receiver),
                  itemName: itemNameInitial,
                  personName: result['chat_room']['sender_name'],
                  itemDescription: description,
                  pagePop: false,
                  requestReceiver: result['chat_room']['request_receiver'],
                  requestSender: result['chat_room']['request_sender'],
                  isReported: false,
        )));
      /*updateChat(context, result['chat_details']['sender'], result['chat_details']['receiver'], 
        //itemNameInitial + ", " + 
        result['chat_details']['title'], result['chat_details']['sender_name'], 
        result['chat_details']['req_desc'], false, result['chat_details']['request_receiver'], result['chat_details']['request_sender']);*/
      returnBool =  false;
    }
    else {
      Fluttertoast.showToast(msg: result['message']);
      returnBool =  false;
    }
  } catch (e) {
    print(e.toString());
    returnBool = false;
  }
  return returnBool ;
}

var bodyUpdateChatRoom = {
    'title': 'itemName',
    "request_sender": 1,
    "request_receiver": 'sender',
    'req_desc':'hjnlkm'
  };

updateChat(BuildContext context, int senderID, int receiverID, String itemNameFinal, String personName, String itemDescription, bool pagePop, int requestReceiver, int requestSender) async{
  print("I am in update chat");
  try {
    bodyUpdateChatRoom['title'] = itemNameFinal;
    bodyUpdateChatRoom["request_sender"] = requestSender;
	  bodyUpdateChatRoom["request_receiver"] = requestReceiver;
    bodyUpdateChatRoom['req_desc'] = itemDescription;
    final token = await SharedPrefsCustom().getToken();
    final response = await http.post(
      URL_UPDATE_CHAT,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
      body: json.encode(
        bodyUpdateChatRoom
    ));

    print("Body of update chat is " + bodyUpdateChatRoom.toString() );
    print("response of update chat is "+response.body.toString());
    final result = json.decode(response.body);
    print("Result of create chat room is "+result.toString());
    if (result["code"] == 200) {
      Future.delayed(
          Duration(seconds: 2),
          () => Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) =>
                  ChatScreenPage(
                    senderID: senderID,
                    receiverID: receiverID,
                    itemName: itemNameFinal,
                    personName: personName,
                    itemDescription: itemDescription,
                    pagePop: pagePop,
                    requestReceiver: requestReceiver,
                    requestSender: requestSender,
                    isReported: false,
                  ))));
    }
    else {
      Fluttertoast.showToast(msg: result['message']);
    }
  } catch (e) {
    print(e.toString());
  }
}
