import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_hestia/model/request.dart';
import 'package:project_hestia/utils.dart';
import 'package:project_hestia/widgets/requests_card.dart';

class RequestsFeedScreen extends StatefulWidget {
  static const routename = '/feed';

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
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
        opacity: (_fabIsVisible) ? 1.0 : 0.0,
        child: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () {},
          tooltip: 'Add ',
          child: Icon(Icons.add),
        ),
      ),
      body: CustomScrollView(
        controller: fabController,
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            expandedHeight: MediaQuery.of(context).size.height * 0.15,
            snap: true,
            floating: true,
            backgroundColor: Theme.of(context).canvasColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                  bottom: 16, left: MediaQuery.of(context).size.width * 0.1),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Requests'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    child: CircleAvatar(
                      backgroundColor: mainColor,
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
