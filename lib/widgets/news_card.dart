import 'package:flutter/material.dart';
import 'package:project_hestia/model/news.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/date_formatter.dart';
import 'package:project_hestia/services/url_launcher.dart';

class NewsCard extends StatelessWidget {
  final Item newsItem;
  final String source;
  NewsCard(this.newsItem, this.source);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
      width: MediaQuery.of(context).size.width,
      // height: 100,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 0,
                color: Color(0x23000000),
                // color: Colors.grey[600].withOpacity(0.1),
                // offset: Offset(0.5, 0.5),
              )
            ]
            // boxShadow: [
            //   BoxShadow(
            //       color: Color(0x10101010), blurRadius: 3, spreadRadius: 0.0005)
            // ],

            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    newsItem.title,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              source ?? 'Unkown',
              style: TextStyle(fontWeight: FontWeight.bold),
              // ysoftWrap: false,
              overflow: TextOverflow.fade,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              newsItem.contentSnippet,
              maxLines: 4,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  dateFormatter(newsItem.isoDate),
                  style: TextStyle(color: Colors.grey),
                ),
                FlatButton(
                  onPressed: () => launchURL(context, newsItem.link),
                  textColor: mainColor,
                  child: Text(
                    'Read Full Story',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}