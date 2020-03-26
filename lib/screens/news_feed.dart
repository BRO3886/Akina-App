import 'package:flutter/material.dart';
import 'package:project_hestia/Profile/profilePage.dart';
import 'package:project_hestia/model/news.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/widgets/news_card.dart';

String desc =
    'This is the description of the news we can show upto 60 words here and then if they want they can click on the link below and visit it. Makes sense eh?';
List<News> newsList = [
  News(
      title: 'Title of the news',
      source: 'Source',
      shortDescription: desc,
      dateTime: 'Date and Time'),
  News(
      title: 'Title of the news',
      source: 'Source',
      shortDescription: desc,
      dateTime: 'Date and Time'),
  News(
      title: 'Title of the news',
      source: 'Source',
      shortDescription: desc,
      dateTime: 'Date and Time'),
  News(
      title: 'Title of the news',
      source: 'Source',
      shortDescription: desc,
      dateTime: 'Date and Time'),
  News(
      title: 'Title of the news',
      source: 'Source',
      shortDescription: desc,
      dateTime: 'Date and Time'),
  News(
      title: 'Title of the news',
      source: 'Source',
      shortDescription: desc,
      dateTime: 'Date and Time'),
  News(
      title: 'Title of the news',
      source: 'Source',
      shortDescription: desc,
      dateTime: 'Date and Time'),
];

enum Options {
  Profile,
  Logout,
}

class NewsFeedScreen extends StatelessWidget {
  static const routename = "/newsfeed";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            expandedHeight: MediaQuery.of(context).size.height * 0.10,
            snap: true,
            floating: true,
            title: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'News',
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
                    //print("profile clicked");

                    Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext
                        context) => ProfilePage()));

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
