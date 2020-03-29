import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_hestia/model/global.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_hestia/services/view_all_requests.dart';

deleteRequest(String id) async {
  String result;
  Position position;
  PermissionStatus permissionStatus =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
  if (permissionStatus != PermissionStatus.granted) {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
    if (permissions[PermissionGroup.location] != PermissionStatus.granted) {
      return 'Required Permissions Not Granted';
    }
  }
  try {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.unknown) {
      position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
      // return AllRequests(
      //     message: 'Required Permissions Not Granted', request: []);
    }
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    final address = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(position.latitude, position.longitude));
  
    print(address.first.locality);
    final uri = Uri.https(
      REQUEST_BASE_URL,
      URL_NEW_REQUEST+id+"/",
    );
    print(REQUEST_BASE_URL+
      URL_NEW_REQUEST+id+"/");
    final token = await SharedPrefsCustom().getToken();
    final response = await http.delete(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );
    print("Response for delete is "+response.body.toString());
    if (response.statusCode == 200) {
      result = "Request successfully deleted";
      getAllRequests();
      Fluttertoast.showToast(msg: "Request successfully deleted");
    } else if (response.statusCode == 204) {
      result = 'No requests found';
      Fluttertoast.showToast(msg: "No requests found");
    } else {
      result = 'Something\'s wrong on our end';
      Fluttertoast.showToast(msg: "Something\'s wrong on our end");
    }
  } catch (e) {
    print(e.toString());
  }
  return result;
}
