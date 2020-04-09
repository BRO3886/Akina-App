import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart' as piechart;
import 'package:project_hestia/model/country_data_stats.dart';
import 'package:project_hestia/model/util.dart';

class CountryStatisticsScreen extends StatefulWidget {
  @override
  _CountryStatisticsScreenState createState() =>
      _CountryStatisticsScreenState();
}

class _CountryStatisticsScreenState extends State<CountryStatisticsScreen> {
  String selectedRegion = "Afghanistan";
  Future<List<String>> countryList;
  final formatter = NumberFormat("#,###");
  @override
  void initState() {
    countryList = getCountries();

    super.initState();
  }

  Widget horizontalDivider() {
    return Container(
      height: MediaQuery.of(context).size.width * 0.1,
      width: 1,
      color: Colors.grey[200],
    );
  }

  Widget returnStats(final data, String title, Color color) {
    return Column(
      children: <Widget>[
        Text(
          formatter.format(data),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.fromFuture(countryList),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<String> countries = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey[400],
                    ),
                  ),
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text('Select Country'),
                      value: selectedRegion,
                      isDense: true,
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                        });
                        print(selectedRegion);
                      },
                      items: countries.map((String country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: Stream.fromFuture(getStatsforcountry(selectedRegion)),
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      CountryData countryData = snapshot.data;
                      print(countryData.countryData.deaths);
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    // color: Colors.grey[600].withOpacity(0.1),
                                    color: Color(0x23000000),
                                  ),
                                ]),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: ListTile(
                              title: Text('Total Cases'),
                              trailing: Text(
                                formatter.format(countryData.countryData.cases),
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    // color: Colors.grey[600].withOpacity(0.1),
                                    color: Color(0x23000000),
                                  ),
                                ]),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                returnStats(
                                  countryData.countryData.active,
                                  'Active',
                                  colorYellow,
                                ),
                                horizontalDivider(),
                                returnStats(
                                  countryData.countryData.recovered,
                                  'Recovered',
                                  mainColor,
                                ),
                                horizontalDivider(),
                                returnStats(
                                  countryData.countryData.deaths,
                                  'Deceased',
                                  colorPink,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10),
                            child: piechart.PieChart(
                              chartValueBackgroundColor: Colors.grey[200],
                              showLegends: false,
                              decimalPlaces: 1,
                              dataMap: {
                                "active": countryData.countryData.active + .0,
                                "recovered":
                                    countryData.countryData.recovered + .0,
                                "deaths": countryData.countryData.deaths + .0,
                              },
                              colorList: [colorYellow, mainColor, colorPink],
                              chartRadius:
                                  MediaQuery.of(context).size.width / 2.7,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

Future<List<String>> getCountries() async {
  List<String> countries = [];
  final String url = "http://hestia-info.herokuapp.com/allCountries";
  try {
    final response = await http.get(url);
    print(response.statusCode);
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
