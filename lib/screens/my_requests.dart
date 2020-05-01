/*import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/new_req_screen.dart';

import 'package:project_hestia/services/view_my_requests.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';
import 'package:project_hestia/widgets/requests_delete_card.dart';

class MyRequestsPage extends StatefulWidget {
  static const routename = '/reqfeed';

  @override
  _MyRequestsPageState createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  ScrollController fabController = ScrollController();

  var _fabIsVisible = true;
  bool _dataIsLoaded = false;
  double _fabHeight = 55;
  double _fabWidth = 55;

  @override
  void initState() {
    _fabIsVisible = true;
    super.initState();
    fabController.addListener(() {
      if (fabController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_fabIsVisible == false) {
          setState(() {
            _fabIsVisible = true;
            _fabHeight = 55;
            _fabWidth = 55;
          });
        }
      } else {
        if (_fabIsVisible == true) {
          setState(() {
            _fabIsVisible = false;
            _fabHeight = 0;
            _fabWidth = 0;
          });
        }
      }
    });
    //takeValues();
  }

  @override
  void dispose() {
    fabController.dispose();
    getMyRequests();
    super.dispose();
  }

  AllRequests allRequests;
  takeValues() async{
    allRequests = await getMyRequests();
    if(this.mounted){
      setState(() {
        allRequests;
        print('New value of requests is '+allRequests.toString());  
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        height: _fabHeight,
        width: _fabWidth,
        child: FloatingActionButton(
          elevation: 4,
          backgroundColor: mainColor,
          onPressed: () =>
              Navigator.of(context).pushNamed(NewRequestScreen.routename),
          tooltip: 'New request',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.ease,
            height: _fabHeight / 2,
            width: _fabWidth / 2,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(
              Icons.add,
              size: _fabHeight / 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: getMyRequests(),
        builder: (ctx, snapshot) {
          print('Snapshot is '+snapshot.toString());
          if (snapshot.hasData) {
            AllRequests allRequests = snapshot.data;
            //print('Data in my requests is '+allRequests.request.length.toString());
            //  allRequests.request = allRequests.request.reversed.toList();
            if (allRequests.request.length <= 0) {
              return CustomScrollView(
                controller: fabController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  MySliverAppBar(
                    title: 'My Requests',
                    isReplaced: false,
                    hideIcon: true,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(allRequests.message),
                    ),
                  )
                ],
              );
            } else {
              return CustomScrollView(
                controller: fabController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  MySliverAppBar(
                    title: 'My Requests',
                    isReplaced: false,
                    hideIcon: true,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RequestDeleteCard(allRequests.request[index], allRequests.request.length),
                      );
                    }, childCount: allRequests.request.length),
                  ),
                ],
              );
            }
          } else {
            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ),
                MySliverAppBar(
                  title: 'My Requests',
                  isReplaced: false,
                  hideIcon: true,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ),
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}*/

  /*Future<AllRequests> getMyRequests() async {
    print('i am in get my requests');
    AllRequests allRequests;
    Position position;
    PermissionStatus permissionStatus =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
    if (permissionStatus != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.location]);
      if (permissions[PermissionGroup.locationAlways] != PermissionStatus.granted) {
        return AllRequests(
            message: 'Required Permissions Not Granted', request: []);
      }
    }
    try {
      ServiceStatus serviceStatus = await PermissionHandler().checkServiceStatus(PermissionGroup.locationAlways);
      if(serviceStatus == ServiceStatus.disabled){
        return AllRequests(message: 'Your location is disabled', request: []);
      }
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus();
      if (geolocationStatus == GeolocationStatus.unknown) {
        position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
        // return AllRequests(
        //     message: 'Required Permissions Not Granted', request: []);
      }
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      final address = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(position.latitude, position.longitude));
      print(address.first.locality);
      final uri = Uri.https(
        REQUEST_BASE_URL,
        URL_VIEW_MY_REQUESTS,
        {
          //TODO change location
          'location': address.first.locality
          },
      );
      print("URI in my request is "+uri.toString());
      final token = await SharedPrefsCustom().getToken();
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: token,
        },
      );
      print("Response code of view my request is "+response.statusCode.toString());
      if (response.statusCode == 204) {
        return AllRequests(message: 'No requests found.', request: []);
      } else if (response.statusCode == 200) {
        AllRequests allRequests = allRequestsFromJson(response.body);
        allRequests.request.sort((a,b)=>b.dateTimeCreated.compareTo(a.dateTimeCreated));
        return allRequests;
      } else {
        allRequests =
            AllRequests(message: 'Something\'s wrong on our end', request: []);
      }
    } catch (e) {
      print(e.toString());
    }
    return allRequests;
  }*/




import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/new_req_screen.dart';
import 'dart:io';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_hestia/model/global.dart';
import 'package:http/http.dart' as http;
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/services/delete_request.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import '../model/request.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';
import 'package:project_hestia/widgets/requests_delete_card.dart';

class MyRequestsPage extends StatefulWidget {
  static const routename = '/reqfeed';

  @override
  _MyRequestsPageState createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  ScrollController fabController = ScrollController();

  var _fabIsVisible = true;
  bool _dataIsLoaded = false;
  double _fabHeight = 55;
  double _fabWidth = 55;

  @override
  void initState() {
    _fabIsVisible = true;
    super.initState();
    fabController.addListener(() {
      if (fabController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_fabIsVisible == false) {
          setState(() {
            _fabIsVisible = true;
            _fabHeight = 55;
            _fabWidth = 55;
          });
        }
      } else {
        if (_fabIsVisible == true) {
          setState(() {
            _fabIsVisible = false;
            _fabHeight = 0;
            _fabWidth = 0;
          });
        }
      }
    });
    all = getMyRequestsMethod();
  }

  @override
  void dispose() {
    fabController.dispose();
    getMyRequestsMethod();
    super.dispose();
  }

  Future<AllRequests> all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        height: _fabHeight,
        width: _fabWidth,
        child: FloatingActionButton(
          elevation: 4,
          backgroundColor: mainColor,
          onPressed: () =>
              Navigator.of(context).pushNamed(NewRequestScreen.routename).then(
                (value){
                  setState(() {                  
                    all = getMyRequestsMethod();
                  });
                }
              ),
          tooltip: 'New request',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.ease,
            height: _fabHeight / 2,
            width: _fabWidth / 2,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(
              Icons.add,
              size: _fabHeight / 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: all,
        builder: (ctx, snapshot) {
          print('Snapshot is '+snapshot.toString());
          if (snapshot.hasData) {
            //allRequests = snapshot.data;
            print('Data in my requests is '+allRequests.request.length.toString());
            //  allRequests.request = allRequests.request.reversed.toList();
            if (allRequests.request.length <= 0) {
              return CustomScrollView(
                controller: fabController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  MySliverAppBar(
                    title: 'My Requests',
                    isReplaced: false,
                    hideIcon: true,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(allRequests.message),
                    ),
                  )
                ],
              );
            } else {
              return CustomScrollView(
                controller: fabController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  MySliverAppBar(
                    title: 'My Requests',
                    isReplaced: false,
                    hideIcon: true,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: requestDeleteCard(allRequests.request[index], context),
                      );
                    }, childCount: allRequests.request.length),
                  ),
                ],
              );
            }
          } else {
            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ),
                MySliverAppBar(
                  title: 'My Requests',
                  isReplaced: false,
                  hideIcon: true,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ),
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  AllRequests allRequests;

  Future<AllRequests> getMyRequestsMethod() async {
    Position position;
    PermissionStatus permissionStatus =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
    if (permissionStatus != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.location]);
      if (permissions[PermissionGroup.locationAlways] != PermissionStatus.granted) {
        return AllRequests(
            message: 'Required Permissions Not Granted', request: []);
      }
    }
    try {
      ServiceStatus serviceStatus = await PermissionHandler().checkServiceStatus(PermissionGroup.locationAlways);
      if(serviceStatus == ServiceStatus.disabled){
        return AllRequests(message: 'Your location is disabled', request: []);
      }
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus();
      if (geolocationStatus == GeolocationStatus.unknown) {
        position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
        // return AllRequests(
        //     message: 'Required Permissions Not Granted', request: []);
      }
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      final address = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(position.latitude, position.longitude));
      print(address.first.locality);
      final uri = Uri.https(
        REQUEST_BASE_URL,
        URL_VIEW_MY_REQUESTS,
        {
          //TODO change location
          'location': address.first.locality
          },
      );
      print("URI in my request is "+uri.toString());
      final token = await SharedPrefsCustom().getToken();
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: token,
        },
      );
      // print("Response code of view my request is "+response.statusCode.toString());
      print("Response body of view my request is "+response.body.toString());
      if (response.statusCode == 204) {
        setState(() {
          allRequests = AllRequests(message: 'No requests found.', request: []);
        });
        return AllRequests(message: 'No requests found.', request: []);
      } else if (response.statusCode == 200) {
        allRequests = allRequestsFromJson(response.body);
        allRequests.request.sort((a,b)=>b.dateTimeCreated.compareTo(a.dateTimeCreated));
        setState(() {
          allRequests = allRequestsFromJson(response.body);
          allRequests.request.sort((a,b)=>b.dateTimeCreated.compareTo(a.dateTimeCreated));
        });
        return allRequests;
      } else {
        setState(() {
          allRequests =
              AllRequests(message: 'Something\'s wrong on our end', request: []);
        });
        return allRequests;
      }
    } catch (e) {
      print(e.toString());
    }
    return allRequests;
  }

  bool cardDeleted =  false;
  requestDeleteCard(Request request, BuildContext cardContext){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
    width: MediaQuery.of(cardContext).size.width,
    // height: 125,
    child: Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 5),
              child: Text(
                request.description ?? 'No description provided',
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
        title: Row(
          children: <Widget>[
            Text(request.itemName, style: TextStyle(color: colorBlack),),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 10),
            //   height: 15,
            //   color: Colors.grey[200],
            //   width: 1,
            // ),
            // Expanded(
            //   child: Text(
            //     widget.request.quantity,
            //     overflow: TextOverflow.fade,
            //     softWrap: false,
            //     style: TextStyle(fontWeight: FontWeight.w500),
            //   ),
            // ),
          ],
        ),
        subtitle: Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                request.quantity,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: colorBlack),
              ),
              Text(
                dateFormatter(request.dateTimeCreated),
                style: TextStyle(color: colorBlack),
              ),
            ],
          ),
        ),
        trailing: GestureDetector(
          onTap: () async {
            if (cardDeleted == false) {
              showDialog(
                barrierDismissible: false,
                context: cardContext,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Text(
                        'Deleting...',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }
                        
            bool deleted =
                await deleteRequest(request.id.toString());
            if (deleted == true) {
              Navigator.of(cardContext).pop();
              setState(() {
                cardDeleted = true;
                all = getMyRequestsMethod();
              });
              showDialog(
                barrierDismissible: true,
                context: cardContext,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  content: Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          child: Icon(
                            Icons.delete,
                            color: colorWhite,
                            size: 30,
                          ),
                          radius: 30,
                          backgroundColor: colorRed,
                        ),
                        Text(
                          'Your Request has been deleted',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      textColor: mainColor,
                      child: Text('Close'),
                      onPressed: () => Navigator.of(cardContext).pop(),
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
      ),
    ),
  );
  }
}
