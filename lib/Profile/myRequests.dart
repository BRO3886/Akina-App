import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/new_req_screen.dart';

class MyRequestsPage extends StatefulWidget {
  MyRequestsPage({Key key, this.userID}) : super(key: key);
  final String userID;

  @override
  MyRequestsPageState createState() => MyRequestsPageState();
}

class MyRequestsPageState extends State<MyRequestsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => addRequest(),
          backgroundColor: mainColor,
          child: Icon(Icons.add, color: Colors.white,),
        ),
        // floatingActionButton: GestureDetector(
        //   onTap: () {
        //     addRequest();
        //   },
        //   child: Container(
        //       padding: EdgeInsets.all(10.0),
        //       margin: EdgeInsets.only(left: 25, bottom: 20),
        //       decoration: BoxDecoration(
        //         boxShadow: <BoxShadow>[
        //           BoxShadow(
        //             color: Colors.grey[600],
        //             offset: Offset(0.5, 0.5),
        //             blurRadius: 1.0,
        //           ),
        //         ],
        //         shape: BoxShape.circle,
        //         color: mainColor,
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Icon(
        //             Icons.add,
        //             color: colorWhite,
        //           ),
        //         ],
        //       )),
        // ),
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Theme.of(context).canvasColor,
          iconTheme: IconThemeData(color: colorBlack),
          // title: Text(
          //'Profile',
          // style: TextStyle(color: colorBlack, fontSize: 24.0),
          //),
          // actions: <Widget>[
          //   Container(
          //     margin: EdgeInsets.only(right: 20.0),
          //     child : Icon(Icons.account_circle,color: colorBlue,)
          //   )
          // ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0, bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'My Requests',
                          style: TextStyle(
                              color: colorBlack,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                            //margin: EdgeInsets.only(right: 10.0),
                            child: Icon(
                          Icons.account_circle,
                          color: mainColor,
                          size: 40.0,
                        ))
                      ],
                    ),
                  ),
                  new Expanded(
                      child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Container(
                                margin: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          blurRadius: 3.0,
                                          color: Colors.grey[600],
                                          offset: Offset(0.5, 0.5))
                                    ],
                                    shape: BoxShape.rectangle,
                                    color: colorWhite,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 20.0,
                                            left: 15.0,
                                            bottom: 20.0),
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Name',
                                                    style: TextStyle(
                                                        fontSize: 17.0),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 18.0),
                                                      child: Text(
                                                        '4',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Text('Date and Time',
                                                style: TextStyle(
                                                    color: colorGrey,
                                                    fontSize: 14.0))
                                          ],
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 20.0,
                                            right: 15.0,
                                            bottom: 20.0),
                                        padding: EdgeInsets.all(8.0),
                                        decoration: new BoxDecoration(
                                          color: colorRed,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color: colorWhite,
                                          size: 14.0,
                                        )),
                                  ],
                                ));
                          }))
                ])));
  }

  String name;
  int quantity;

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  addRequest() {
    Navigator.of(context).pushNamed(NewRequestScreen.routename);
  }
  // addRequest() {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => new AlertDialog(
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  //       content: Container(
  //         height: MediaQuery.of(context).size.height / 2,
  //         child: Form(
  //           key: _key,
  //           autovalidate: _validate,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Expanded(
  //                 child: Container(
  //                     padding: EdgeInsets.only(top: 6.0),
  //                     child: Theme(
  //                         data: ThemeData(
  //                           primaryColor: mainColor,
  //                           accentColor: mainColor,
  //                         ),
  //                         child: TextFormField(
  //                             maxLines: 1,
  //                             maxLength: 100,
  //                             cursorColor: mainColor,
  //                             style: TextStyle(color: mainColor),
  //                             decoration: const InputDecoration(
  //                               border: OutlineInputBorder(),
  //                               hintText: 'Name of thing',
  //                               labelStyle: TextStyle(
  //                                   //color: mainColor,
  //                                   ),
  //                             ),
  //                             keyboardType: TextInputType.text,
  //                             autofocus: true,
  //                             validator: (val) => (val.length == 0)
  //                                 ? 'Please enter a name'
  //                                 : null,
  //                             onSaved: (String val) {
  //                               setState(() {
  //                                 name = val;
  //                               });
  //                             }))),
  //               ),
  //               Expanded(
  //                 child: Container(
  //                     padding: EdgeInsets.only(top: 6.0),
  //                     child: Theme(
  //                         data: ThemeData(
  //                           primaryColor: mainColor,
  //                           accentColor: mainColor,
  //                         ),
  //                         child: TextFormField(
  //                             cursorColor: mainColor,
  //                             style: TextStyle(color: mainColor),
  //                             decoration: const InputDecoration(
  //                               border: OutlineInputBorder(),
  //                               hintText: 'Quantity',
  //                               labelStyle: TextStyle(
  //                                   //color: mainColor,
  //                                   ),
  //                             ),
  //                             keyboardType: TextInputType.number,
  //                             autofocus: true,
  //                             validator: (val) => (val.length == 0)
  //                                 ? 'Please enter some quantity'
  //                                 : null,
  //                             onSaved: (val) {
  //                               setState(() {
  //                                 quantity = val as int;
  //                               });
  //                             }))),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   GestureDetector(
  //                       onTap: () {},
  //                       child: Container(
  //                           alignment: Alignment.center,
  //                           margin: EdgeInsets.only(top: 30.0, right: 10.0),
  //                           padding: EdgeInsets.only(
  //                               right: 16.0, left: 16.0, top: 8.0, bottom: 8.0),
  //                           decoration: BoxDecoration(
  //                               shape: BoxShape.rectangle,
  //                               color: mainColor,
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(10))),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                             children: <Widget>[
  //                               Text(
  //                                 "Done",
  //                                 style: TextStyle(color: colorWhite),
  //                               ),
  //                               Container(
  //                                   margin: EdgeInsets.only(left: 10.0),
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: colorWhite,
  //                                   ))
  //                             ],
  //                           ))),
  //                   GestureDetector(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Container(
  //                           alignment: Alignment.center,
  //                           margin: EdgeInsets.only(top: 30.0),
  //                           padding: EdgeInsets.only(
  //                               right: 16.0, left: 16.0, top: 8.0, bottom: 8.0),
  //                           decoration: BoxDecoration(
  //                               shape: BoxShape.rectangle,
  //                               color: mainColor,
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(10))),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                             children: <Widget>[
  //                               Text(
  //                                 "Cancel",
  //                                 style: TextStyle(color: colorWhite),
  //                               ),
  //                               Container(
  //                                   margin: EdgeInsets.only(left: 10.0),
  //                                   child: Icon(
  //                                     Icons.close,
  //                                     color: colorWhite,
  //                                   ))
  //                             ],
  //                           ))),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
