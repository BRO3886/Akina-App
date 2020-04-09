import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:intl/intl.dart';
import 'package:project_hestia/model/util.dart';

class MyLineChart extends StatelessWidget {
  MyLineChart({
    Key key,
    @required this.cases,
    @required this.color,
  }) : super(key: key);

  final NumberFormat formatter = NumberFormat("#,###");
  final List<double> cases;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  formatter.format(cases[cases.length - 1]),
                  style: TextStyle(fontSize: 10.0, color: colorGrey),
                ),
                Text(
                  'Number',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                Text(formatter.format(cases[0]),
                    style: TextStyle(fontSize: 10.0, color: colorGrey)),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 10.0),
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: colorGrey,
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: colorGrey,
                    width: 1.0,
                  ),
                ),
              ),
              child: Sparkline(
                data: cases,
                fillMode: FillMode.below,
                fillColor: color.withOpacity(0.5),
                lineColor: color,
              )),
        ],
      ),
    );
  }
}
