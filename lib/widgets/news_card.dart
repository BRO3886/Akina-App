import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:project_hestia/model/news.dart';
import 'package:project_hestia/model/util.dart';

class NewsCard extends StatelessWidget {
  final Item newsItem;
  final String source;
  NewsCard(this.newsItem,this.source);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  newsItem.title,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 15,
                  color: Colors.grey[200],
                  width: 1,
                ),
                Text(
                  source,
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
              newsItem.contentSnippet,
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
                  '${newsItem.isoDate.day} ${newsItem.isoDate.month} ${newsItem.isoDate.year}',
                  style: TextStyle(color: Colors.grey),
                ),
                FlatButton(
                  onPressed: () => _launchURL(context, newsItem.link),
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

void _launchURL(BuildContext context, String url) async {
  try {
    await launch(
      url,
      option: new CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        enableInstantApps: true,
        // animation: new CustomTabsAnimation.,
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
