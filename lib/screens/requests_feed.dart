import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/new_req_screen.dart';
import 'package:project_hestia/services/view_all_requests.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';
import 'package:project_hestia/widgets/profile_icon.dart';
import 'package:project_hestia/widgets/requests_card.dart';

class RequestsFeedScreen extends StatefulWidget {
  static const routename = '/reqfeed';

  @override
  _RequestsFeedScreenState createState() => _RequestsFeedScreenState();
}

class _RequestsFeedScreenState extends State<RequestsFeedScreen> {
  ScrollController fabController = ScrollController();

  var _fabIsVisible = true;
  bool _dataIsLoaded = false;
  double _fabHeight = 55;
  double _fabWidth = 55;

  

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
      body: FutureBuilder(
        future: getAllRequests(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            AllRequests allRequests = snapshot.data;
            if (allRequests.request.length <= 0) {
              return CustomScrollView(
                controller: fabController,
                slivers: <Widget>[
                  MySliverAppBar(title: 'Requests',),
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
                  MySliverAppBar(title: 'Requests',),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, index) {
                      return RequestCard(allRequests.request[index]);
                    }, childCount: allRequests.request.length),
                  ),
                ],
              );
            }
          } else {
            return CustomScrollView(
              slivers: <Widget>[
                MySliverAppBar(title: 'Requests',),
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
