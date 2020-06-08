import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/create_shop_suggestion.dart';
import 'package:project_hestia/services/accept_request.dart';
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

import '../model/request.dart';

class RequestCard extends StatefulWidget {
  final Request request;
  bool shopStatus, requestStatus;
  RequestCard(this.request,this.requestStatus, this.shopStatus);
  @override
  _RequestCardState createState() => new _RequestCardState();
}

Color _color = Colors.grey;
Color _headingColor = Colors.black;

class _RequestCardState extends State<RequestCard> {
  SharedPrefsCustom s = new SharedPrefsCustom();

  @override
  void initState() {
    super.initState();
    //getValues();
  }

  
  /*Future<bool> checkShopStatus;
  Future<bool> checkRequestStatus;
  bool shopStatus, requestStatus;

  getValues() {
    checkShopStatus = s.getShopStatus();
    checkShopStatus.then((resultString) {
      setState(() {
        shopStatus = resultString;
      });

      checkRequestStatus = s.getRequestStatus();
      checkRequestStatus.then((resultStringLogin) {
        setState(() {
          requestStatus = resultStringLogin;
        });
        print("Value of check and shop check is "+ requestStatus.toString() +" "+shopStatus.toString() );
      });
    });
  }*/

  final Request request;
  bool shopStatus, requestStatus;
  _RequestCardState({this.request, 
  this.requestStatus, this.shopStatus
    });

  bool load = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(0, 0),
      children: <Widget>[
      Container(
      // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20),
      //height: 125,
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
                    print("Value of shop in shop is "+ shopStatus.toString());
                    if (widget.shopStatus == true) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CreateShopSuggestionScreen(
                                    userID: widget.request.id.toString(),
                                    itemName: widget.request.itemName,
                                  )));
                    } else if (widget.shopStatus == false || widget.shopStatus == null) {
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
                  onTap: () async {
                    print("Value of accept in check is "+widget.requestStatus.toString());
                    if (widget.requestStatus == true) {
                      setState(() {
                        load = true;
                        //Fluttertoast.showToast(msg: 'Its true');
                      });
                      load = await acceptRequest(context, widget.request.id.toString(),widget.request.itemName, widget.request.requestMadeBy, widget.request.description);
                      // setState(() {
                      //   load = false;
                      // });
                      /*.then((value) {
                          print("called with value = null");
                          setState(() {
                            load;
                          });
                        }).whenComplete(() {
                          print("called when future completes");
                        });*/
                    } else if (widget.requestStatus == false || widget.requestStatus == null ) {
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
    ),
    load == true ?
      new Center(
        child : Container(
        //height: 200.0,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
        color: Colors.grey.withOpacity(0.5),
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text('Processing the request...'),
          ],
        )
      )
     ) : Container()
    ],
    );
  }

  acceptWidget(
      BuildContext context, int itemID, String itemName, String receiverID, String description) {
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (dialogContext, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(dialogContext).canvasColor,
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
                            onPressed: () async{
                              Navigator.pop(dialogContext);
                              setState(() {
                                load = true;
                                //Fluttertoast.showToast(msg: 'Its true');
                              });
                              load = await acceptRequest(context, widget.request.id.toString(),widget.request.itemName, widget.request.requestMadeBy, widget.request.description);
                              // setState(() {
                              //   load;
                              //load == false ? Fluttertoast.showToast(msg: 'Noooo') : Container( color: Colors.red, width: 10.0, height: 10.0,);
                              //});
                              /*acceptRequest(context, itemID.toString(),
                                  itemName, receiverID, description).then((value) {
                                      print("called with value = null " + value.toString());
                                      if(value == false && mounted){
                                        setState(() {
                                          load = value;
                                          Fluttertoast.showToast(msg: 'Its false');
                                        });
                                      }
                                      if(mounted){
                                        setState(() {
                                          load = false;
                                          Fluttertoast.showToast(msg: 'Its false');
                                        });
                                      }
                                    }).whenComplete(() {
                                      print("called when future completes");
                                    });*/
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
                            onPressed: () => Navigator.of(dialogContext).pop(),
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
                            widget.requestStatus = !widget.requestStatus;
                            s.setRequestStatus(widget.requestStatus);
                            print("Value of accept is "+widget.requestStatus.toString());
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 10.0,
                              backgroundColor: mainColor,
                              child: widget.requestStatus ? SvgPicture.asset(
                                "assets/images/check.svg",
                                color : colorWhite,
                                height: 8.0,
                                width: 8.0,
                              ) : Container(
                                decoration: BoxDecoration(
                                  color : colorWhite,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorGrey
                                  )
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Do not show again',
                              style: TextStyle(
                                  fontSize: 10.0,
                                  color: widget.requestStatus ? mainColor : colorBlack),
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

  //bool shop = false;

  suggestShop(BuildContext context, String userID, String itemName) {
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (dialogContext, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(dialogContext).canvasColor,
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
                              Navigator.pop(dialogContext);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => CreateShopSuggestionScreen(
                                    itemName: itemName,
                                    userID: widget.request.requestMadeBy,
                                  ),
                                ),
                              );
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
                            onPressed: () => Navigator.of(dialogContext).pop(),
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
                            widget.shopStatus =  !widget.shopStatus;
                            s.setShopStatus(widget.shopStatus);
                            print("Value of shop is "+ widget.shopStatus.toString());
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 10.0,
                              backgroundColor: mainColor,
                              child: widget.shopStatus ? SvgPicture.asset(
                                "assets/images/check.svg",
                                color : colorWhite,
                                height: 8.0,
                                width: 8.0,
                              ) : Container(
                                decoration: BoxDecoration(
                                  color : colorWhite,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorGrey
                                  )
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Do not show again',
                              style: TextStyle(
                                  fontSize: 10.0,
                                  color: widget.shopStatus ? mainColor : colorBlack),
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
