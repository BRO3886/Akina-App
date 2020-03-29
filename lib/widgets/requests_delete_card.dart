import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/services/delete_request.dart';
import 'package:project_hestia/services/view_all_requests.dart';

import '../model/request.dart';

class RequestDeleteCard extends StatelessWidget {
  final Request request;
  RequestDeleteCard(this.request);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
      width: MediaQuery.of(context).size.width,
      height: 125,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 0,
              // color: Colors.grey[600].withOpacity(0.1),
              color: Color(0x23000000),
            ),
          ],
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        // elevation: 0,
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 2, left: 14, right: 14),
          title: Row(
            children: <Widget>[
              Text(request.itemName),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 15,
                color: Colors.grey[200],
                width: 1,
              ),
              Text(request.quantity),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(dateFormatter(request.dateTimeCreated)),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  deleteRequest(request.id.toString());
                },
                child: Tooltip(
                  message: 'Delete my request',
                  child: CircleAvatar(
                    child: Icon(
                      Icons.delete,
                      color: colorWhite,
                      size: 14.0,
                    ),
                    maxRadius: 15,
                    backgroundColor: colorRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
