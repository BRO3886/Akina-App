import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:project_hestia/model/news.dart';
import 'package:project_hestia/model/util.dart';

class NewsCard extends StatelessWidget {
  final News news;
  NewsCard(this.news);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      width: MediaQuery.of(context).size.width,
      // height: 100,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 0.5,
                color: Colors.grey[600].withOpacity(0.1),
                offset: Offset(0.5, 0.5),
              )
            ]
            // boxShadow: [
            //   BoxShadow(
            //       color: Color(0x10101010), blurRadius: 3, spreadRadius: 0.0005)
            // ],

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
                      news.dateTime,
                      style: TextStyle(color: Colors.grey),
                    ),
                    FlatButton(
                      onPressed: ()=>_launchURL(context),
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
        ),
      ),
    );
  }
}

void _launchURL(BuildContext context) async {
  try {
    await launch(
      'https://dscvit.com/',
      option: new CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        enableInstantApps: true,
        animation: new CustomTabsAnimation.fade(),
        // // or user defined animation.
        // animation: new CustomTabsAnimation(
        //   startEnter: 'slide_up',
        //   startExit: 'android:anim/fade_out',
        //   endEnter: 'android:anim/fade_in',
        //   endExit: 'slide_down',
        // ),
        // extraCustomTabs: <String>[
        //   // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
        //   'org.mozilla.firefox',
        //   // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
        //   'com.microsoft.emmx',
        // ],
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}
