import 'dart:io';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_hestia/model/global.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/model/shop.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import '../model/request.dart';
import 'package:permission_handler/permission_handler.dart';

Future<AllShops> getAllShops() async {
  AllShops allShops;
  Position position;
  PermissionStatus permissionStatus =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
  if (permissionStatus != PermissionStatus.granted) {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
    if (permissions[PermissionGroup.location] != PermissionStatus.granted) {
      return AllShops(
          message: 'Required Permissions Not Granted', shop: []);
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
    // final uri = Uri.https(
    //   SHOP_BASE_URL,
    //   URL_SHOW_SHOPS,
    //   {'location': address.first.locality},
    // );
    final token = await SharedPrefsCustom().getToken();
    final response = await http.get(
      URL_SHOW_SHOPS,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );
     print(response.statusCode);
    if (response.statusCode == 200) {
      allShops = allShopsFromJson(response.body);
      print(allShops.shop.toString());
    } else if (response.statusCode == 204) {
      allShops = AllShops(message: 'No shops found', shop: []);
    } else {
      allShops = AllShops(message: 'Something\'s wrong on our end', shop: []);
    }
  } catch (e) {
    print(e.toString());
  }
  return allShops;
}
