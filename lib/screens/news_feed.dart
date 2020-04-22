import 'package:flutter/material.dart';
import 'package:project_hestia/model/news.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/statistics_page.dart';
import 'package:project_hestia/services/get_news.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';
import 'package:project_hestia/widgets/news_card.dart';

class NewsFeedScreen extends StatelessWidget {
  static const routename = "/newsfeed";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
      future: getNews(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          News news = snapshot.data;
          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
              MySliverAppBar(
                title: 'News',
                isReplaced: true,
              ),
              SliverToBoxAdapter(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      StatisticsPage()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 17),
                          //width: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 0,
                                color: Color(0x23000000),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.pie_chart,
                              color: mainColor,
                              size: 25,
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: new BoxDecoration(
                                color: mainColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: colorWhite,
                                size: 14.0,
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 2, left: 14, right: 14),
                            title: Text(
                              'Statistics',
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                    ]),
                /*SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),*/
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((ctx, index) {
                  return NewsCard(news.items[index], news.source);
                }, childCount: news.items.length),
              ),
              // SliverFillRemaining(
              //   hasScrollBody: false,
              //   child: SingleChildScrollView(
              //     child: Column(
              //       children: <Widget>[
              //         for (int i = 0; i < newsList.length; i++)
              //           NewsCard(newsList[i])
              //       ],
              //     ),
              //   ),
              // )
            ],
          );
        } else {
          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
              MySliverAppBar(
                title: 'News',
                isReplaced: true,
              ),
              SliverToBoxAdapter(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            StatisticsPage()));
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 25.0,
                                    right: 25.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 17),
                                //width: MediaQuery.of(context).size.width * 0.75,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      spreadRadius: 0,
                                      color: Color(0x23000000),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.pie_chart,
                                    color: mainColor,
                                    size: 25,
                                  ),
                                  trailing: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: new BoxDecoration(
                                      color: mainColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: colorWhite,
                                      size: 14.0,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      top: 2, left: 14, right: 14),
                                  title: Text(
                                    'Statistics',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ])) /*SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),*/
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
    ));
  }
}

// String desc =
//     'This is the description of the news we can show upto 60 words here and then if they want they can click on the link below and visit it. Makes sense eh?';
// List<News> newsList = [
//   News(
//       title: 'Title of the news',
//       source: 'Source',
//       shortDescription: desc,
//       dateTime: 'Date and Time'),
//   News(
//       title: 'Title of the news',
//       source: 'Source',
//       shortDescription: desc,
//       dateTime: 'Date and Time'),
//   News(
//       title: 'Title of the news',
//       source: 'Source',
//       shortDescription: desc,
//       dateTime: 'Date and Time'),
//   News(
//       title: 'Title of the news',
//       source: 'Source',
//       shortDescription: desc,
//       dateTime: 'Date and Time'),
//   News(
//       title: 'Title of the news',
//       source: 'Source',
//       shortDescription: desc,
//       dateTime: 'Date and Time'),
//   News(
//       title: 'Title of the news',
//       source: 'Source',
//       shortDescription: desc,
//       dateTime: 'Date and Time'),
//   News(
//       title: 'Title of the news',
//       source: 'Source',
//       shortDescription: desc,
//       dateTime: 'Date and Time'),
// ];
