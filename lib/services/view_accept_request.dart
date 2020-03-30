import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_hestia/model/getViewAccepts.dart';
import 'package:project_hestia/model/global.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/services/shared_prefs_custom.dart';
import '../model/request.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<Accept>> viewAcceptRequest() async {
  List<Accept> listOfAccept;
  try {
    final token = await SharedPrefsCustom().getToken();
    final response = await http.get(
      URL_VIEW_ACCEPT_REQUESTS,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );
    //print("response is "+response.body.toString());
    final result = jsonDecode(response.body);
    // print("Response code is "+response.statusCode.toString());
    // print("Result in view accepts is "+result.toString());
    if (response.statusCode == 200) {
      listOfAccept = ViewAccepts.fromJson(result).accepts;
      print("List is "+listOfAccept.toString());
    } else {
      listOfAccept = [];
    }
  } catch (e) {
    print(e.toString());
  }
  return listOfAccept;
}
