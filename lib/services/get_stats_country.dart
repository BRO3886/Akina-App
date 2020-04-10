import 'package:project_hestia/model/country_data_stats.dart';
import 'package:http/http.dart' as http;

Future<CountryData> getStatsforcountry(String country) async {
  final url = "http://hestia-info.herokuapp.com/allCountriesData/$country";
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      CountryData countryData = countryDataFromJson(response.body);
      return countryData;
    }
  } catch (e) {
    print(e.toString());
  }
}
