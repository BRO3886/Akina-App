import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:project_hestia/model/global.dart';
import 'package:project_hestia/model/util.dart';
import 'package:flutter/foundation.dart';
import 'package:project_hestia/model/worldStats.dart';
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart' as pieChart;
import '../widgets/line_chart.dart';

class WorldStatsPage extends StatefulWidget {
  WorldStatsPage({Key key, this.userID}) : super(key: key);
  final int userID;

  @override
  WorldStatsPageState createState() => WorldStatsPageState();
}

class WorldStatsPageState extends State<WorldStatsPage> {
  final formatter = NumberFormat("#,###");
  final int userID;
  WorldStatsPageState({this.userID});
  @override
  void initState() {
    super.initState();
    getWorldStats();

    dataMap.putIfAbsent("Recent Cases", () => 1);
    dataMap.putIfAbsent("Death Cases", () => 1);
    dataMap.putIfAbsent("Recovered Cases", () => 1);
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

  SharedPrefsCustom s = new SharedPrefsCustom();

  WorldStats listOfStats;
  int total = 0;
  int activeCases = 0, recovered = 0, deaths = 0, totalCases = 0;
  List<double> listActivecase = [], listRecovered = [], listDeath = [], listTotalCase = [];
  List<ActiveCases> listDateActive;
  List<Recovered> listDateRecovered;
  List<Deaths> listDateDeath;
  List<TotalCases> listDateTotal;

  String snapshot = '';

  Future<WorldStats> getWorldStats() async {
    try {
      final response = await http.get(URL_WORLD_STATISTICS, headers: {
        'content-type': 'application/json; charset = utf-8',
      });

      print("Response of world stats is " + response.statusCode.toString());
      final data = json.decode(response.body);
      print('Data in world stats is ' + data.toString());
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            listOfStats = WorldStats.fromJson(data['time_series']);
            snapshot = 'hasData';
            for (int i = 0; i < listOfStats.cases.length; i++) {
              listActivecase.add(listOfStats.cases[i].number.toDouble());
              activeCases += listOfStats.cases[i].number;
            }
            for (int i = 0; i < listOfStats.deaths.length; i++) {
              listDeath.add(listOfStats.deaths[i].number.toDouble());
              deaths += listOfStats.deaths[i].number;
            }
            for (int i = 0; i < listOfStats.recovered.length; i++) {
              listRecovered.add(listOfStats.recovered[i].number.toDouble());
              recovered += listOfStats.recovered[i].number;
            }
            for (int i = 0; i < listOfStats.totalCases.length; i++) {
              listTotalCase.add(listOfStats.totalCases[i].number.toDouble());
              totalCases += listOfStats.totalCases[i].number;
            }
            listDateActive = listOfStats.cases;
            listDateRecovered = listOfStats.recovered;
            listDateDeath = listOfStats.deaths;
            listDateTotal = listOfStats.totalCases;

            total = activeCases + deaths + recovered;
            dataMap = {
              ((listOfStats.globalData.recentCase * 100) / listOfStats.globalData.recentTotalCases).toStringAsPrecision(3) + " %":
                  (listOfStats.globalData.recentCase * 100) / listOfStats.globalData.recentTotalCases,   
              ((listOfStats.globalData.recentRecovered * 100) / listOfStats.globalData.recentTotalCases).toStringAsPrecision(3) + " %":
                  (listOfStats.globalData.recentRecovered * 100) / listOfStats.globalData.recentTotalCases,
              ((listOfStats.globalData.recentDeath * 100) / listOfStats.globalData.recentTotalCases).toStringAsPrecision(3) + " %":
                  (listOfStats.globalData.recentDeath * 100) / listOfStats.globalData.recentTotalCases,
            };
          });
        }
      } else {
        setState(() {
          snapshot = data['message'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
    return listOfStats;
  }

  Map<String, double> dataMap = Map();
  List<Color> colorList = [colorYellow, mainColor, colorPink];

  Container bottomDataRow(final myDataList) {
    return Container(
      width: 300.0,
      alignment: Alignment(1, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(""),
          Text(dateFormatter(myDataList[0].date).toString(),
              style: TextStyle(fontSize: 12.0, color: colorGrey)),
          Text(
            'Date',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          Text(dateFormatter(myDataList[myDataList.length - 1].date).toString(),
              style: TextStyle(fontSize: 12.0, color: colorGrey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (snapshot == 'hasData') {
      if (listActivecase.length > 0) {
        return new SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 0,
                          color: Color(0x23000000),
                        ),
                      ]),
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                      vertical: 5.0),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ListTile(
                    trailing: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          formatter.format(listOfStats.globalData.recentTotalCases),
                          style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        )),
                    title: Text(
                      'Total Cases',
                      textAlign: TextAlign.left,
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
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        returnStats(listOfStats.globalData.recentCase, 'Active', colorYellow),
                        horizontalDivider(),
                        returnStats(listOfStats.globalData.recentRecovered, 'Recovered', mainColor),
                        horizontalDivider(),
                        returnStats(listOfStats.globalData.recentDeath, 'Deceased', colorPink),
                      ]),
                ),
                SizedBox(
                  height: 18.0,
                ),
                pieChart.PieChart(
                  chartValueStyle: TextStyle(color: Colors.transparent),
                  dataMap: dataMap,
                  chartRadius: MediaQuery.of(context).size.width / 2.7,
                  showChartValues: true,
                  showChartValuesOutside: false,
                  colorList: colorList,
                  showLegends: true,
                  decimalPlaces: 1,
                  chartType: pieChart.ChartType.disc,
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  "Trend Plots",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Text(
                  'Total Cases',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                MyLineChart(
                  cases: listTotalCase,
                  color: mainColor,
                ),
                bottomDataRow(listDateTotal),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Active Cases',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: colorYellow),
                ),
                MyLineChart(
                  cases: listActivecase,
                  color: colorYellow,
                ),
                bottomDataRow(listDateActive),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Deceased',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: colorPink),
                ),
                MyLineChart(
                  cases: listDeath,
                  color: colorPink,
                ),
                bottomDataRow(listDateDeath),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Recovered',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                MyLineChart(
                  cases: listRecovered,
                  color: mainColor,
                ),
                bottomDataRow(listDateRecovered),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1,)
              ],
            ),
          ),
        );
      } else {
        return Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Center(
              child: Text('No stats found'),
            ),
          ],
        );
      }
    } else {
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
    }
  }

}
