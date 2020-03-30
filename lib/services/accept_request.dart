import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_hestia/model/global.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/services/shared_prefs_custom.dart';
import '../model/request.dart';
import 'package:permission_handler/permission_handler.dart';

acceptRequest(String itemID, String itemName, String receiverID) async {
  Position position;
  PermissionStatus permissionStatus =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
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
    final senderID = await SharedPrefsCustom().getUserID();
    
    final response = await http.post(
      URL_ACCEPT_REQUEST,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
      body: {
        'request_id':itemID.toString(),
        'location': 'Noida'
        
        //TODO change locationaddress.first.locality
      }
    );
    print("response is "+response.body.toString());
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      createChat(senderID, receiverID, itemName);
      //Fluttertoast.showToast(msg: 'Request accepted!');
    } else {
        Fluttertoast.showToast(msg: result['message']);
    }
  } catch (e) {
    print(e.toString());
  }
}

createChat(int sender, String receiver, String text) async{  
  print("I am in create chat");
  try {
    final token = await SharedPrefsCustom().getToken();
    final response = await http.post(
      URL_CREATE_CHAT,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
      body: json.encode({
        'receiver': int.parse(receiver),
        'sender': sender ,
        'title': text
      })
    );
    print("response is "+response.body.toString());
    final result = json.decode(response.body);
    if (result["status"] == 200) {
      Fluttertoast.showToast(msg: 'Request accepted!');
    } else {
        Fluttertoast.showToast(msg: result['message']);
    }
  } catch (e) {
    print(e.toString());
  }
}
