import 'package:flutter/material.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/services/delete_request.dart';

import '../model/request.dart';

class RequestDeleteCard extends StatefulWidget {
  final Request request;
  RequestDeleteCard(this.request);

  @override
  _RequestDeleteCardState createState() => _RequestDeleteCardState();
}

class _RequestDeleteCardState extends State<RequestDeleteCard> {
  bool cardDeleted = false;
  @override
  Widget build(BuildContext context) {
    return (cardDeleted)
        ? Container()
        : Container(
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
                    Text(widget.request.itemName),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 15,
                      color: Colors.grey[200],
                      width: 1,
                    ),
                    Text(
                      widget.request.quantity,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(dateFormatter(widget.request.dateTimeCreated)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        if (cardDeleted == false) {
                          showDialog(
                            context: context,
                            useRootNavigator: true,
                            child: AlertDialog(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  Text(
                                    'Deleting...',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        bool deleted =
                            await deleteRequest(widget.request.id.toString());
                        if (deleted == true) {
                          Navigator.of(context).pop();
                          setState(() {
                            cardDeleted = true;
                          });
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              content: Text(
                                'Request Deleted',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  textColor: mainColor,
                                  child: Text('Close'),
                                  onPressed: () =>
                                      Navigator.of(context).maybePop(),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Tooltip(
                        message: 'Delete this request',
                        child: CircleAvatar(
                          child: Icon(
                            Icons.delete,
                            color: colorWhite,
                            size: 18.0,
                          ),
                          maxRadius: 20,
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
