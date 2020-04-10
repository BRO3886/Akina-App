import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_hestia/Profile/chatScreen.dart';
import 'package:project_hestia/model/global.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/services/shared_prefs_custom.dart';
import '../model/request.dart';
import 'package:permission_handler/permission_handler.dart';

acceptRequest(BuildContext context ,String itemID, String itemName, String receiverID, String description) async {
  Position position;
  PermissionStatus permissionStatus =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
  if (permissionStatus != PermissionStatus.granted) {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
    if (permissions[PermissionGroup.location] != PermissionStatus.granted) {
      Fluttertoast.showToast(msg: 'Required Permissions Not Granted');
      return AllRequests(
          message: 'Required Permissions Not Granted', request: []);
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
        'location': address.first.locality
        //TODO: change location address.first.locality
      }
    );
    print("response is "+response.body.toString());
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      createChat(context, senderID, receiverID, itemName, description);
      //Fluttertoast.showToast(msg: 'Request accepted!');

      //I/flutter ( 6821): response is {"message":"Item Already Accepted"}

    } else if(result['message'].toString().contains('blocked')){
      Fluttertoast.showToast(msg: 'You cannot accept this request');
    } else {
        Fluttertoast.showToast(msg: result['message']);
    }
  } catch (e) {
    print(e.toString());
  }
}

var bodyCreateChatRoom = {
    'receiver' : 1,
    'sender': 'sender',
    'title': 'itemName',
    "request_sender": 1,
    "request_receiver": 'sender',
    'req_desc' : 'description'
  };

createChat(BuildContext context, int sender, String receiver, String itemName, String description) async{  
  print("I am in create chat");
  try {
    bodyCreateChatRoom['receiver'] = int.parse(receiver);
    bodyCreateChatRoom['sender'] = sender ;
    bodyCreateChatRoom['title'] = itemName;
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
      print("Description is "+description +" "+sender.toString()+" "+int.parse(receiver).toString()+" "+itemName+" "+result['chat_room']['sender_name'].toString());
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                ChatScreenPage(
                  senderID: sender,
                  receiverID: int.parse(receiver),
                  itemName: itemName,
                  personName: result['chat_room']['sender_name'],
                  itemDescription: description,
                  pagePop: false,
                  requestReceiver: result['chat_room']['request_receiver'],
                  requestSender: result['chat_room']['request_sender'],
        )));
    } else if(result["status"] == 500){
      Fluttertoast.showToast(msg: 'Something went wrong. Please try again later');
    }
    else {
      Fluttertoast.showToast(msg: result['message']);
    }
  } catch (e) {
    print(e.toString());
  }
}
