/*import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/new_req_screen.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:project_hestia/services/view_all_requests.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';
import 'package:project_hestia/widgets/requests_card.dart';

class RequestsFeedScreen extends StatefulWidget {
  static const routename = '/reqfeed';

  @override
  _RequestsFeedScreenState createState() => _RequestsFeedScreenState();
}

class _RequestsFeedScreenState extends State<RequestsFeedScreen> {
  ScrollController fabController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var _fabIsVisible = true;
  // bool _dataIsLoaded = false;
  double _fabHeight = 55;
  double _fabWidth = 55;
  Future<AllRequests> data = getAllRequests();

  @override
  void initState() {
    // getAllRequests();
    _fabIsVisible = true;
    super.initState();
    // fabController = ScrollController();
    fabController.addListener(() {
      if (fabController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // do something
        if (_fabIsVisible == false) {
          setState(() {
            _fabIsVisible = true;
            _fabHeight = 55;
            _fabWidth = 55;
          });
        }
      } else {
        //do something
        if (_fabIsVisible == true) {
          setState(() {
            _fabIsVisible = false;
            _fabHeight = 0;
            _fabWidth = 0;
          });
        }
      }
    });
    getValues();
  }

  SharedPrefsCustom s = new SharedPrefsCustom();

  Future<bool> checkShopStatus;
  Future<bool> checkRequestStatus;
  bool shopStatus, requestStatus;

  getValues() {
    checkShopStatus = s.getShopStatus();
    checkShopStatus.then((resultString) {
      if(mounted){
        setState(() {
          shopStatus = resultString;
        });

        checkRequestStatus = s.getRequestStatus();
        checkRequestStatus.then((resultStringLogin) {
          setState(() {
            requestStatus = resultStringLogin;
          });
          //print("Value of check and shop check is "+ requestStatus.toString() +" "+shopStatus.toString() );
        });
      }
    });
  }

  @override
  void dispose() {
    fabController.dispose();
    super.dispose();
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
      body: RefreshIndicator(
        displacement: MediaQuery.of(context).size.height * 0.13,
        key: _refreshIndicatorKey,
        onRefresh: (){
          setState(() {
            data = getAllRequests();
          });
          return data;
        },
        child: FutureBuilder(
          future: data,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              AllRequests allRequests = snapshot.data;
              // allRequests.request = allRequests.request.reversed.toList();
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
                      title: 'Requests',
                      isReplaced: true,
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: true,
                      child: Center(
                        child: Text(allRequests.message),
                      ),
                    ),
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
                      title: 'Requests',
                      isReplaced: true,
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((ctx, index) {
                        getValues();
                        return RequestCard(allRequests.request[index],requestStatus, shopStatus);
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
                    title: 'Requests',
                    isReplaced: true,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
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
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/new_req_screen.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:project_hestia/services/view_all_requests.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';
import 'package:project_hestia/widgets/requests_card.dart';

class RequestsFeedScreen extends StatefulWidget {
  static const routename = '/reqfeed';

  @override
  _RequestsFeedScreenState createState() => _RequestsFeedScreenState();
}

class _RequestsFeedScreenState extends State<RequestsFeedScreen> {
  ScrollController fabController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var _fabIsVisible = true;
  // bool _dataIsLoaded = false;
  double _fabHeight = 55;
  double _fabWidth = 55;
  Future<AllRequests> data = getAllRequests();

  @override
  void initState() {
    // getAllRequests();
    _fabIsVisible = true;
    super.initState();
    // fabController = ScrollController();
    fabController.addListener(() {
      if (fabController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // do something
        if (_fabIsVisible == false) {
          setState(() {
            _fabIsVisible = true;
            _fabHeight = 55;
            _fabWidth = 55;
          });
        }
      } else {
        //do something
        if (_fabIsVisible == true) {
          setState(() {
            _fabIsVisible = false;
            _fabHeight = 0;
            _fabWidth = 0;
          });
        }
      }
    });
    getValues();
  }

  SharedPrefsCustom s = new SharedPrefsCustom();

  Future<bool> checkShopStatus;
  Future<bool> checkRequestStatus;
  bool shopStatus, requestStatus;

  getValues() {
    checkShopStatus = s.getShopStatus();
    checkShopStatus.then((resultString) {
      if(mounted){
        setState(() {
          shopStatus = resultString;
        });

        checkRequestStatus = s.getRequestStatus();
        checkRequestStatus.then((resultStringLogin) {
          setState(() {
            requestStatus = resultStringLogin;
          });
          //print("Value of check and shop check is "+ requestStatus.toString() +" "+shopStatus.toString() );
        });
      }
    });
  }

  @override
  void dispose() {
    fabController.dispose();
    super.dispose();
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
      body: RefreshIndicator(
        displacement: MediaQuery.of(context).size.height * 0.13,
        key: _refreshIndicatorKey,
        onRefresh: (){
          setState(() {
            data = getAllRequests();
          });
          return data;
        },
        child: Stack(
          children: <Widget>[
            FutureBuilder(
              future: data,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  AllRequests allRequests = snapshot.data;
                  // allRequests.request = allRequests.request.reversed.toList();
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
                          title: 'Requests',
                          isReplaced: true,
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: true,
                          child: Center(
                            child: Text(allRequests.message),
                          ),
                        ),
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
                          title: 'Requests',
                          isReplaced: true,
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((ctx, index) {
                            getValues();
                            return RequestCard(allRequests.request[index],requestStatus, shopStatus);
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
                        title: 'Requests',
                        isReplaced: true,
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
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
          ],
        ) 
      ),
    );
  }
}

