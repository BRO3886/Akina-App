import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> getCountries() async {
  List<String> countries = [];
  final String url = "http://hestia-info.herokuapp.com/allCountries";
  try {
    final response = await http.get(url);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> resBody = json.decode(response.body);
      // print(resBody);
      countries = resBody["allCountries"].cast<String>();
      countries = countries.map((country) => country).toList();
      countries.sort((a, b) => a.compareTo(b));
      // print(countries);
    }
    return countries;
  } catch (e) {
    print(e.toString());
  }
}