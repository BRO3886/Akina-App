import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:project_hestia/utils.dart';

import '../model/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  RequestCard(this.request);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color(0x10101010), blurRadius: 3, spreadRadius: 0.0005)
          ],
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text(request.title),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 15,
                  color: Colors.grey,
                  width: 1,
                ),
                Text(request.qty.toString()),
              ],
            ),
            subtitle: Text(request.dateTime),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  maxRadius: 15,
                  backgroundColor: mainColor,
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  maxRadius: 15,
                  backgroundColor: mainColor,
                ),
              ],
            ),
            // trailing: Row(children: <Widget>[
            //   CircleAvatar(child: Icon(AntIcons.home),),
            //   CircleAvatar(child: Icon(Icons.done),),
            // ],),
          ),
        ),
      ),
    );
  }
}
