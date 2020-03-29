import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

Future<AllRequests> viewMyRequests() async {
  final sp = SharedPrefsCustom();
  final token = await sp.getToken();
  // TODO: --better practice-- remove later and proivde config file
  final uri = 'https://hestia-requests.herokuapp.com/api/requests/my_requests/';
  try {
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      return AllRequests(message: 'No requests found.', request: []);
    } else if (response.statusCode == 200) {
      AllRequests allRequests = allRequestsFromJson(response.body);
      return allRequests;
    } else {
      return AllRequests(
          message:
              'Something\'s wrong on our end. We\'re working hard to fix it.',
          request: []);
    }
  } catch (e) {}
}
