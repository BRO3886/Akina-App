import 'package:flutter/material.dart';
import 'package:project_hestia/model/news.dart';
import 'package:project_hestia/widgets/news_card.dart';

import '../utils.dart';

String desc = 'This is the description of the news we can show upto 60 words here and then if they want they can click on the link below and visit it. Makes sense eh?';
List<News> newsList = [
  News(title: 'Title of the news', source: 'Source', shortDescription: desc, dateTime: 'Date and Time'),
  News(title: 'Title of the news', source: 'Source', shortDescription: desc, dateTime: 'Date and Time'),
  News(title: 'Title of the news', source: 'Source', shortDescription: desc, dateTime: 'Date and Time'),
  News(title: 'Title of the news', source: 'Source', shortDescription: desc, dateTime: 'Date and Time'),
  News(title: 'Title of the news', source: 'Source', shortDescription: desc, dateTime: 'Date and Time'),
  News(title: 'Title of the news', source: 'Source', shortDescription: desc, dateTime: 'Date and Time'),
  News(title: 'Title of the news', source: 'Source', shortDescription: desc, dateTime: 'Date and Time'),
];

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
                  for (int i = 0; i < newsList.length; i++)
                    NewsCard(newsList[i])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
