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
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart' as pieChart;
import 'package:fl_chart/fl_chart.dart';
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

    seriesList = _createSampleData();

    dataMap.putIfAbsent("Flutter", () => 1);
    dataMap.putIfAbsent("React", () => 1);
    dataMap.putIfAbsent("Xamarin", () => 1);
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
  int activeCases = 0, recovered = 0, deaths = 0;
  List<double> listActivecase = [], listRecovered = [], listDeath = [];
  List<Cases> listDateActive;
  List<Recovered> listDateRecovered;
  List<Deaths> listDateDeath;

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
            listDateActive = listOfStats.cases;
            listDateRecovered = listOfStats.recovered;
            listDateDeath = listOfStats.deaths;

            total = activeCases + deaths + recovered;
            dataMap = {
              ((activeCases * 100) / total).toStringAsPrecision(3) + " %":
                  (activeCases * 100) / total,
              ((deaths * 100) / total).toStringAsPrecision(3) + " %":
                  (deaths * 100) / total,
              ((recovered * 100) / total).toStringAsPrecision(3) + " %":
                  (recovered * 100) / total
            };
            _createSampleData();
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

  List<charts.Series> seriesList;
  List<charts.Series<Cases, int>> _createSampleData() {
    final myFakeDesktopData = listDateActive;

    /*var myFakeTabletData = [
      new LinearSales(0, 10),
      new LinearSales(1, 50),
      new LinearSales(2, 200),
      new LinearSales(3, 150),
    ];

    var myFakeMobileData = [
      new LinearSales(0, 15),
      new LinearSales(1, 75),
      new LinearSales(2, 300),
      new LinearSales(3, 225),
    ];*/

    return [
      new charts.Series<Cases, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Cases cases, _) => 1,
        measureFn: (Cases cases, _) => cases.number,
        data: myFakeDesktopData,
      ),
    ];
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  bool showAvg = false;

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
    /*return FutureBuilder(
        future: getWorldStats(),
        builder: (ctx, snapshot) {
          */
    if (snapshot == 'hasData') {
      if (listActivecase.length > 0) {
        return new SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1400,
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
                          // color: Colors.grey[600].withOpacity(0.1),
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
                          formatter.format(total),
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
                        returnStats(activeCases, 'Active', colorYellow),
                        horizontalDivider(),
                        returnStats(recovered, 'Recovered', mainColor),
                        horizontalDivider(),
                        returnStats(deaths, 'Deceased', colorPink),
                      ]),
                ),
                SizedBox(
                  height: 18.0,
                ),
                pieChart.PieChart(
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
              ],
            ),
          ),
        );
      } else {
        return Text("No stats found");
      }
    } else {
      return CircularProgressIndicator();
    }
  }

}
