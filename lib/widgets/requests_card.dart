import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/shop_suggestios.dart';
import 'package:project_hestia/services/accept_request.dart';
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/widgets/accept_dialog_box.dart';

import '../model/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  RequestCard(this.request);
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
                  suggestShop(context);
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
                  print("I am in accept req");
                  //AcceptRequestWidget(request.id.toString());
                  //acceptRequest(request.id.toString());
                  acceptWidget(context, request.id.toString());
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

  acceptWidget(BuildContext context,String id){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      content: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircleAvatar(
              child: SvgPicture.asset("assets/images/check.svg", width: 23.0, height: 23.0,),
              //maxRadius: 20,
              backgroundColor: mainColor,
              radius: 30.0,
            ),
            Text('You have this item?', style: TextStyle(fontWeight: FontWeight.bold),), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: mainColor,
                  textColor: colorWhite,
                  onPressed: (){
                    acceptRequest(id);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
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
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('No'),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.clear, color: colorBlack, size: 16.0,)
                    ],
                  ),
                ),
              ],
            )
          ],
        )
      ),
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
    ));
  }

  suggestShop(BuildContext context){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      content: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircleAvatar(
              child: SvgPicture.asset("assets/images/store.svg", width: 23.0, height: 23.0,),
              radius: 30,
              backgroundColor: mainColor,
            ),
            Text('Suggest a shop?', style: TextStyle(fontWeight: FontWeight.bold),), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: mainColor,
                  textColor: colorWhite,
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder:
                                (BuildContext context) =>
                                    ShopSuggestionsScreen()));
                    //Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
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
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('No'),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.clear, color: colorBlack, size: 16.0,)
                    ],
                  ),
                ),
              ],
            )
          ],
        )
      ),
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
    ));
  }
}
