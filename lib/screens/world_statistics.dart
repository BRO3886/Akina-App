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
      /*new charts.Series<LinearSales, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeTabletData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Mobile',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeMobileData,
      ),*/
    ];
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  bool showAvg = false;

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
                      margin: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 17),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 0,
                            color: Color(0x23000000),
                          ),
                        ],
                      ),
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
                        contentPadding:
                            EdgeInsets.only(top: 2, left: 14, right: 14),
                        title: Text(
                          'Total Cases',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 17),
                      //width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 0,
                            color: Color(0x23000000),
                          ),
                        ],
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    formatter.format(activeCases),
                                    style: TextStyle(
                                      color: colorYellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        bottom: 10.0, top: 10.0),
                                    child: Text(
                                      'Active Cases',
                                      style: TextStyle(
                                          color: colorGrey, fontSize: 12.0),
                                    )),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    formatter.format(recovered),
                                    style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        bottom: 10.0, top: 10.0),
                                    child: Text(
                                      'Recovered',
                                      style: TextStyle(
                                          color: colorGrey, fontSize: 12.0),
                                    )),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    formatter.format(deaths),
                                    style: TextStyle(
                                      color: colorPink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        bottom: 10.0, top: 10.0),
                                    child: Text(
                                      'Deceased',
                                      style: TextStyle(
                                          color: colorGrey, fontSize: 12.0),
                                    ))
                              ],
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    pieChart.PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 100),
                      chartLegendSpacing: 32.0,
                      chartRadius: MediaQuery.of(context).size.width / 2.7,
                      showChartValuesInPercentage: true,
                      showChartValues: true,
                      showChartValuesOutside: false,
                      chartValueBackgroundColor: Colors.grey[200],
                      colorList: colorList,
                      showLegends: true,
                      legendPosition: pieChart.LegendPosition.right,
                      decimalPlaces: 1,
                      showChartValueLabel: true,
                      initialAngle: 0,
                      chartValueStyle: pieChart.defaultChartValueStyle.copyWith(
                        color: Colors.blueGrey[900].withOpacity(0.9),
                      ),
                      chartType: pieChart.ChartType.disc,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      "Trend Plots",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
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
                    MyLineChart(cases: listActivecase, color: colorYellow,),
                    Container(
                      width: 300.0,
                      alignment: Alignment(1, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(""),
                          Text(
                            dateFormatter(listDateActive[0].date).toString(),
                            style: TextStyle(fontSize: 10.0, color: colorGrey),
                          ),
                          Text(
                            'Date',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            dateFormatter(
                                    listDateActive[listDateActive.length - 1]
                                        .date)
                                .toString(),
                            style: TextStyle(fontSize: 10.0, color: colorGrey),
                          ),
                        ],
                      ),
                    ),
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
                    MyLineChart(cases: listDeath,color: colorPink,),
                    Container(
                      width: 300.0,
                      alignment: Alignment(1, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(""),
                          Text(dateFormatter(listDateDeath[0].date).toString(),
                              style:
                                  TextStyle(fontSize: 10.0, color: colorGrey)),
                          Text(
                            'Date',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              dateFormatter(
                                      listDateDeath[listDateDeath.length - 1]
                                          .date)
                                  .toString(),
                              style:
                                  TextStyle(fontSize: 10.0, color: colorGrey)),
                        ],
                      ),
                    ),
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
                    MyLineChart(cases: listRecovered,color: mainColor,),
                    Container(
                      width: 300.0,
                      alignment: Alignment(1, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(""),
                          Text(
                              dateFormatter(listDateRecovered[0].date)
                                  .toString(),
                              style:
                                  TextStyle(fontSize: 12.0, color: colorGrey)),
                          Text(
                            'Date',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              dateFormatter(listDateRecovered[
                                          listDateRecovered.length - 1]
                                      .date)
                                  .toString(),
                              style:
                                  TextStyle(fontSize: 12.0, color: colorGrey)),
                        ],
                      ),
                    ),
                  ],
                )));
      } else {
        return Text("No stats found");
      }
    } else {
      return CircularProgressIndicator();
    }
    //},
    //);

    //   bodyMyChats()
    // ])
    // );
  }

  lineChart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            /*(){        
            for(int i=0;i<listOfStats.cases.length;i++){
              FlSpot(i.toDouble(), listOfStats.cases[i].number.toDouble());
            }
            return FlSpot(0, 3);
            */
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  /*bodyMyChats(){
    
    if (snapshot == '') {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot == 'hasData' && listMyChats.length == 0) {
      return Center(
        child: Text("No messages found"),
      );
    } else if (snapshot == 'hasData' && listMyChats.length > 0) {
      return new ListView.builder(
                    itemCount: listMyChats.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) => ChatScreenPage(
                                senderID: listMyChats[index].sender,
                                receiverID: listMyChats[index].receiver,
                                itemName: listMyChats[index].title,
                                personName: listMyChats[index].senderName,
                                itemDescription: listMyChats[index].description,
                                pagePop: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                                left: 25.0,
                                right: 25.0,
                                top: 10.0,
                                bottom: 10.0),
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    color: Color(0x23000000),
                                  ),
                                ],
                                shape: BoxShape.rectangle,
                                color: colorWhite,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 20.0, left: 15.0, bottom: 20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 0.0, bottom: 10.0),
                                          child: Text(
                                            listMyChats[index].receiverName,
                                            style: TextStyle(fontSize: 17.0),
                                          ),
                                        ),
                                        Text(listMyChats[index].title,
                                            style: TextStyle(
                                                color: colorGrey,
                                                fontSize: 13.0))
                                      ],
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ChatScreenPage(
                                                  senderID:
                                                      listMyChats[index].sender,
                                                  receiverID: listMyChats[index]
                                                      .receiver,
                                                  itemName:
                                                      listMyChats[index].title,
                                                  personName: listMyChats[index]
                                                      .senderName,
                                                      itemDescription: listMyChats[index].description,
                                                  pagePop: true,
                                                )));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 20.0, right: 15.0, bottom: 20.0),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: new BoxDecoration(
                                        color: mainColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: colorWhite,
                                        size: 14.0,
                                      )),
                                )
                              ],
                            )),
                      );
                    }
              );
    }
    else if(snapshot != null){
      return Container(
        child: Text(snapshot),
      );
    }
    else{
      return Container(
        child : Text('Error is from our side')
      );
    }
  }*/
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
