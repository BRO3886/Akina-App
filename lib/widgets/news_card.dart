import 'package:flutter/material.dart';
import 'package:project_hestia/model/news.dart';
import 'package:project_hestia/utils.dart';

class NewsCard extends StatelessWidget {
  final News news;
  NewsCard(this.news);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      // height: 100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color(0x10101010), blurRadius: 3, spreadRadius: 0.0005)
          ],
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      news.title,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 15,
                      color: Colors.grey,
                      width: 1,
                    ),
                    Text(
                      news.source,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  news.shortDescription,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey,),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      news.dateTime,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Read Full Story',
                      style: TextStyle(color: mainColor),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
