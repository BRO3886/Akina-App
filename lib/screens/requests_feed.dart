import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/utils.dart';
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
          });
        }
      } else {
        //do something
        if (_fabIsVisible == true) {
          setState(() {
            _fabIsVisible = false;
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
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
        opacity: (_fabIsVisible) ? 1.0 : 0.0,
        child: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () {},
          tooltip: 'New request',
          child: Icon(Icons.add),
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
              PopupMenuButton(
                offset: Offset(0, 50),
                onSelected: (Options option){
                  if(option == Options.Profile){
                    print("profile clicked");
                  }else if(option == Options.Logout){
                    print("logout clicked");
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routename);
                  }
                },
                itemBuilder: (ctx) {
                  return [
                    PopupMenuItem(
                      child: Text('Profile'),
                      value: Options.Profile,
                    ),
                    PopupMenuItem(
                      child: Text('Logout'),
                      value: Options.Logout,
                    ),
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 27.0),
                  child: CircleAvatar(
                    backgroundColor: mainColor,
                    child: Icon(
                      Icons.account_circle,
                      size: 40,
                      color: colorWhite,
                    ),
                  ),
                ),
              )
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
