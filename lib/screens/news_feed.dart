import 'package:flutter/material.dart';
import 'package:project_hestia/model/news.dart';
import 'package:project_hestia/services/get_news.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';
import 'package:project_hestia/widgets/news_card.dart';
import 'package:project_hestia/widgets/profile_icon.dart';

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
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
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
