import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_hestia/model/util.dart';

import '../model/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  RequestCard(this.request);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 125,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
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
            child: Text('${request.dateTimeCreated.day}/${request.dateTimeCreated.month}/${request.dateTimeCreated.year}'),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print("suggest shop");
                },
                child: Tooltip(
                  message: 'Suggest a shop',
                  child: CircleAvatar(
                    child: SvgPicture.asset("assets/images/store.svg"),
                    maxRadius: 15,
                    backgroundColor: mainColor,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  print("acpt req");
                },
                child: Tooltip(
                  message: 'Accept this request',
                  child: CircleAvatar(
                    child: SvgPicture.asset("assets/images/check.svg"),
                    maxRadius: 15,
                    backgroundColor: mainColor,
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
