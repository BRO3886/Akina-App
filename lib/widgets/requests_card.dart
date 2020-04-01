import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/create_shop_suggestion.dart';
import 'package:project_hestia/services/accept_request.dart';
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

import '../model/request.dart';

class RequestCard extends StatefulWidget {
  final Request request;
  bool shopStatus, requestStatus;
  RequestCard(this.request, this.requestStatus, this.shopStatus);
  @override
  _RequestCardState createState() => new _RequestCardState();
}

Color _color = Colors.grey;
Color _headingColor = Colors.black;

class _RequestCardState extends State<RequestCard> {
  SharedPrefsCustom s = new SharedPrefsCustom();
  final Request request;
  bool shopStatus, requestStatus;
  _RequestCardState({this.request, this.requestStatus, this.shopStatus});
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20),
      // height: 125,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
        child: ExpansionTile(
          // isThreeLine: true,
          // contentPadding: EdgeInsets.only(top: 2, left: 14, right: 14),
          // onExpansionChanged: (didChange){
          //   if(didChange){
          //     setState(() {
          //       _color = mainColor;
          //       _headingColor = mainColor;
          //     });
          //   }else{
          //     setState(() {
          //       _color = Colors.grey;
          //       _headingColor = Colors.black;
          //     });
          //   }
          // },
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.request.description ?? 'No description provided',
                  style: TextStyle(color: Colors.grey),
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
          ],
          title: Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Text(
                  widget.request.itemName,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(color: _headingColor),
                ),
              ],
            ),
          ),
          subtitle: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.request.quantity,
                  softWrap: false,
                  style: TextStyle(color: _color),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  dateFormatter(widget.request.dateTimeCreated),
                  style: TextStyle(color: _color),
                ),
              ],
            ),
          ),
          trailing: Container(
            margin: const EdgeInsets.only(top: 18.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (shopStatus == true || shop == true) {
                      //Navigator.of(context).maybePop();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CreateShopSuggestionScreen(
                                    userID: widget.request.id.toString(),
                                    itemName: widget.request.itemName,
                                  )));
                    } else if (shopStatus == false || shopStatus == null) {
                      suggestShop(context, widget.request.id.toString(),
                          widget.request.itemName.toString());
                    }
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
                    if (widget.requestStatus == true || (accept == true)) {
                      acceptRequest(
                          context,
                          widget.request.id.toString(),
                          widget.request.itemName,
                          widget.request.requestMadeBy,
                          widget.request.description);
                      Navigator.of(context).maybePop();
                    } else if (widget.requestStatus == false ||
                        widget.requestStatus == null) {
                      acceptWidget(
                          context,
                          widget.request.id,
                          widget.request.itemName,
                          widget.request.requestMadeBy,
                          widget.request.description);
                    }
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
      ),
    );
  }

  bool accept = false;

  acceptWidget(
      BuildContext context, int itemID, String itemName, String receiverID, String description) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              content: Container(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        child: SvgPicture.asset(
                          "assets/images/check.svg",
                          width: 23.0,
                          height: 23.0,
                        ),
                        //maxRadius: 20,
                        backgroundColor: mainColor,
                        radius: 30.0,
                      ),
                      Text(
                        'You have this item?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: mainColor,
                            textColor: colorWhite,
                            onPressed: () {
                              acceptRequest(context, itemID.toString(),
                                  itemName, receiverID, description);
                              Navigator.of(context).maybePop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Yes'),
                                SizedBox(
                                  width: 15,
                                ),
                                SvgPicture.asset("assets/images/check.svg"),
                              ],
                            ),
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: colorWhite,
                            textColor: colorBlack,
                            onPressed: () => Navigator.of(context).pop(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('No'),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.clear,
                                  color: colorBlack,
                                  size: 16.0,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            accept = !accept;
                            s.setRequestStatus(accept);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 10.0,
                              backgroundColor: accept ? mainColor : colorWhite,
                              child: SvgPicture.asset(
                                "assets/images/check.svg",
                                color: accept ? colorWhite : colorBlack,
                                height: 8.0,
                                width: 8.0,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Do not show again',
                              style: TextStyle(
                                  fontSize: 10.0,
                                  color: accept ? mainColor : colorBlack),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          });
        });
  }

  bool shop = false;

  suggestShop(BuildContext context, String userID, String itemName) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              content: Container(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        child: SvgPicture.asset(
                          "assets/images/store.svg",
                          width: 23.0,
                          height: 23.0,
                        ),
                        radius: 30,
                        backgroundColor: mainColor,
                      ),
                      Text(
                        'Suggest a shop?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: mainColor,
                            textColor: colorWhite,
                            onPressed: () {
                              // Navigator.of(context).maybePop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => CreateShopSuggestionScreen(
                                    itemName: itemName,
                                    userID: widget.request.requestMadeBy,
                                  ),
                                ),
                              );
                              //Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Yes'),
                                SizedBox(
                                  width: 15,
                                ),
                                SvgPicture.asset("assets/images/check.svg"),
                              ],
                            ),
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: colorWhite,
                            textColor: colorBlack,
                            onPressed: () => Navigator.of(context).pop(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('No'),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.clear,
                                  color: colorBlack,
                                  size: 16.0,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            shop = !shop;
                            s.setShopStatus(shop);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 10.0,
                              backgroundColor: shop ? mainColor : colorWhite,
                              child: SvgPicture.asset(
                                "assets/images/check.svg",
                                color: shop ? colorWhite : colorBlack,
                                height: 8.0,
                                width: 8.0,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Do not show again',
                              style: TextStyle(
                                  fontSize: 10.0,
                                  color: shop ? mainColor : colorBlack),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              /*actions: <Widget>[
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          color: mainColor,
          textColor: colorWhite,
          onPressed: (){
            acceptRequest(id);
          },
          child: Text('Yes'),
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          color: mainColor,
          textColor: colorWhite,
          onPressed: () => Navigator.of(context).pop(),
          child: Text('No'),
        ),
      ],*/
            );
          });
        });
  }
}
