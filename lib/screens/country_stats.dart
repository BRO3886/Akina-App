import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart' as piechart;
import 'package:project_hestia/model/country_data_stats.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/get_stats_country.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CountryStatisticsScreen extends StatefulWidget {
  final Future<List<String>> countryList;
  CountryStatisticsScreen(this.countryList);
  @override
  _CountryStatisticsScreenState createState() =>
      _CountryStatisticsScreenState();
}

class _CountryStatisticsScreenState extends State<CountryStatisticsScreen> {
  String selectedRegion = "India";

  final formatter = NumberFormat("#,###");
  @override
  void initState() {
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
      stream: Stream.fromFuture(widget.countryList),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        } else {
          List<String> countries = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey[400],
                    ),
                  ),
                  // height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SearchableDropdown.single(
                    underline: Container(),
                    displayClearIcon: false,
                    hint: Text('Select Country'),
                    value: selectedRegion,
                    displayItem:
                        (DropdownMenuItem<String> item, bool selected) {
                      if (selected) {
                        // setState(() {
                        selectedRegion = item.value;
                        // });
                      }
                      return item;
                    },
                    searchHint: Text('Select Country'),
                    isExpanded: true,
                    onChanged: (String value) {
                      // setState(() {
                        selectedRegion = value;
                      // });
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
                StreamBuilder(
                  stream: Stream.fromFuture(getStatsforcountry(selectedRegion)),
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    } else {
                      CountryData countryData = snapshot.data;
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
                              showLegends: true,
                              chartValueStyle:
                                  TextStyle(color: Colors.transparent),
                              showChartValues: false,
                              decimalPlaces: 1,
                              dataMap: {
                                "${double.parse(((countryData.countryData.active / countryData.countryData.cases) * 100).toStringAsFixed(1))}%":
                                    countryData.countryData.active + .0,
                                "${double.parse(((countryData.countryData.recovered / countryData.countryData.cases) * 100).toStringAsFixed(1))}%":
                                    countryData.countryData.recovered + .0,
                                "${double.parse(((countryData.countryData.deaths / countryData.countryData.cases) * 100).toStringAsFixed(1))}%":
                                    countryData.countryData.deaths + .0,
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

/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart' as piechart;
import 'package:project_hestia/model/country_data_stats.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/get_stats_country.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// class CountryStatisticsScreen extends StatefulWidget {
//   final Future<List<String>> countryList;
//   CountryStatisticsScreen(this.countryList);
//   @override
//   _CountryStatisticsScreenState createState() =>
//       _CountryStatisticsScreenState();
// }

class CountryStatisticsScreen extends StatefulWidget {
  
  CountryStatisticsScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CountryStatisticsScreenState();
}

class CountryStatisticsScreenState extends State<CountryStatisticsScreen> {

  @override
  void initState() {
    super.initState();
    fetchAllCountries();
  }

  @override
  void dispose() {
    super.dispose();
  }


  List<String> countries = [];

  fetchAllCountries() async {
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
        setState(() {
          countries;
        });
        // print(countries);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  bool _load = false;
  String selectedCountry;

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            color: colorWhite,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: new CircularProgressIndicator(),
            ),
          )
        : new Container();

    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),
        ),
        body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        child: (DropdownButton(
                          hint: Text('Choose country'),
                          value: selectedCountry,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCountry = newValue;
                            });
                          },
                          items: countries.map((location) {
                            return DropdownMenuItem(
                              child: Container(
                                alignment: Alignment(0, 0),
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.only(bottom: 12.0),
                                    child: new Text(
                                      location,
                                      style:
                                      TextStyle(fontSize: 15.0),
                                ),
                              ),
                              value: location,
                            );
                          }).toList(),
                        ))),
                  ]       
          ),
        );
  }
}*/

/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart' as piechart;
import 'package:project_hestia/model/country_data_stats.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/get_stats_country.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:project_hestia/model/country_data_stats.dart';
import 'package:http/http.dart' as http;


class CountryStatisticsScreen extends StatefulWidget {
  final Future<List<String>> countryList;
  CountryStatisticsScreen(this.countryList);
  @override
  _CountryStatisticsScreenState createState() =>
      _CountryStatisticsScreenState();
}

class _CountryStatisticsScreenState extends State<CountryStatisticsScreen> {
  
  String selectedRegion='India';
  
  final formatter = NumberFormat("#,###");
  @override
  void initState() {
    super.initState();
    getCountries();
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

  String snapshot = '';

  getStatsforcountryNew(String country) async {
    setState(() {
      snapshot = '';
    });
    print("Country is "+country);
    final url = "http://hestia-info.herokuapp.com/allCountriesData/$country";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        CountryData countryData = countryDataFromJson(response.body);
        setState(() {
          countryData;
          snapshot = 'hasData';
        });
        //return countryData;
      }
    } catch (e) {
      print(e.toString());
    }
  }
  
  List<String> countries = [];
  CountryData countryData;

  getCountries() async {
  List<String> countries = [];
  final String url = "http://hestia-info.herokuapp.com/allCountries";
  try {
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> resBody = json.decode(response.body);
      // print(resBody);
      setState(() {  
        countries = resBody["allCountries"].cast<String>();
        countries = countries.map((country) => country).toList();
        countries.sort((a, b) => a.compareTo(b));
        snapshot = 'hasData' ;
      });
      // print(countries);
    }
    return countries;
  } catch (e) {
    print(e.toString());
  }
}

  @override
  Widget build(BuildContext context) {

        if (snapshot == '') {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey[400],
                    ),
                  ),
                  // height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SearchableDropdown.single(
                    underline: Container(),
                    displayClearIcon: false,
                    hint: Text('Select Country'),
                    isCaseSensitiveSearch: false,
                    value: selectedRegion,
                    displayItem: (DropdownMenuItem<String> item, bool selected){
                      if(selected){
                        // setState(() {
                          selectedRegion = item.value;
                        // });
                      }
                      return item;
                    },
                    searchHint: Text('Select Country'),
                    isExpanded: true,
                    onChanged: (String value) {
                      setState(() {
                        selectedRegion = value;
                      });
                      print("Selected country is "+value);
                    },
                    items: countries.map((String country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                  ),
                ),
                (snapshot=='' || countryData == null) ?
                      Center(
                        child: CircularProgressIndicator(),
                      ) :
                      Column(
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
                              showLegends: true,
                              showChartValues: false,
                              decimalPlaces: 1,
                              dataMap: {
                                "${double.parse(((countryData.countryData.active/countryData.countryData.cases)*100).toStringAsFixed(1))}%": countryData.countryData.active + .0,
                                "${double.parse(((countryData.countryData.recovered/countryData.countryData.cases)*100).toStringAsFixed(1))}%":
                                    countryData.countryData.recovered + .0,
                                "${double.parse(((countryData.countryData.deaths/countryData.countryData.cases)*100).toStringAsFixed(1))}%": countryData.countryData.deaths + .0,
                              },
                              colorList: [colorYellow, mainColor, colorPink],
                              chartRadius: MediaQuery.of(context).size.width / 2.7,
                            ),
                          ),
                        ],
                      )
              ],
            ),
          );
        }
  }
}*/
