import 'package:flutter/material.dart';

import '../utils.dart';

class NewsFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                  Text('News'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.335,
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
                  for (int i = 0; i < 10; i++)
                    ListTile(
                      title: Text('hi'),
                      subtitle: Text('hello'),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
