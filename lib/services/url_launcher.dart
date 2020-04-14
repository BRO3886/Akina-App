import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void launchURL(BuildContext context, String url) async {
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

