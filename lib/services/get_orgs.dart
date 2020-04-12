import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/model/orgs.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

Future<Orgs> getOrgsByCountry() async {
  Position position;
  PermissionStatus permissionStatus = await PermissionHandler()
      .checkPermissionStatus(PermissionGroup.locationAlways);
  if (permissionStatus != PermissionStatus.granted) {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
    if (permissions[PermissionGroup.location] != PermissionStatus.granted) {
      return Orgs(
          message: 'Required Permissions Not Granted', organization: []);
    }
  }
  try {
    ServiceStatus serviceStatus = await PermissionHandler()
        .checkServiceStatus(PermissionGroup.locationAlways);
    if (serviceStatus == ServiceStatus.disabled) {
      return Orgs(message: 'Your location is disabled', organization: []);
    }
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.unknown) {
      position = await Geolocator()
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
      // return AllRequests(
      //     message: 'Required Permissions Not Granted', request: []);
    }
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    final address = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(position.latitude, position.longitude));
    print("country for getting orgs is: ${address.first.countryName}");
    final uri = Uri.https(REQUEST_BASE_URL, URL_VIEW_ORGS,
        {'country': address.first.countryName});
    final token = await SharedPrefsCustom().getToken();
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == 200) {
      Orgs orgs = orgsFromJson(response.body);
      print("orgs found");
      return orgs;
    } else if (response.statusCode == 204) {
      return Orgs(
          message: 'No organisations found in your area. To register an organisation visit https://orgregister.netlify.com', organization: []);
    } else {
      return Orgs(
          message: 'Uh oh! Seems like something is wrong on our end',
          organization: []);
    }
  } catch (e) {
    print(e.toString());
  }
}
