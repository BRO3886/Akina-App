import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    fabController.dispose();
    getMyRequests();
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
      body: FutureBuilder(
        future: getMyRequests(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            AllRequests allRequests = snapshot.data;
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
                        child: RequestDeleteCard(allRequests.request[index]),
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
}