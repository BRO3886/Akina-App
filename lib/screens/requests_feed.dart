import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_hestia/Profile/profilePage.dart';
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/widgets/new_request.dart';
<<<<<<< HEAD
=======
import 'package:project_hestia/widgets/profile_icon.dart';
>>>>>>> upstream/master
import 'package:project_hestia/widgets/requests_card.dart';

enum Options {
  Profile,
  Logout,
}

class RequestsFeedScreen extends StatefulWidget {
  static const routename = '/reqfeed';

  @override
  _RequestsFeedScreenState createState() => _RequestsFeedScreenState();
}

class _RequestsFeedScreenState extends State<RequestsFeedScreen> {
  ScrollController fabController = ScrollController();

  var _fabIsVisible = true;

  double _fabHeight = 55;
  double _fabWidth = 55;

  List<Request> requestList = [
    Request(title: 'Name of the thing 1', qty: 5, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 2', qty: 4, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
    Request(title: 'Name of the thing 3', qty: 3, dateTime: 'Date and time'),
  ];

  @override
  void initState() {
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

  void newRequest() {
    showDialog(
      context: context,
      child: NewRequestWidget(),
    );
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
          backgroundColor: mainColor,
          onPressed: newRequest,
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
      body: CustomScrollView(
        controller: fabController,
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            expandedHeight: MediaQuery.of(context).size.height * 0.10,
            snap: true,
            floating: true,
            title: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Requests',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: <Widget>[
              ProfileIcon(),
            ],
            backgroundColor: Theme.of(context).canvasColor,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (int i = 0; i < requestList.length; i++)
                    // ListTile(
                    //   title: Text('hi'),
                    // ),
                    RequestCard(requestList[i])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
