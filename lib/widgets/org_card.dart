import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:project_hestia/model/orgs.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/call_mail_web.dart';

class OrganizationCard extends StatelessWidget {
  final Organization organization;
  OrganizationCard(this.organization);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      margin: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 0,
            // color: Colors.grey[600].withOpacity(0.1),
            color: Color(0x23000000),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(organization.name),
        subtitle: Text(organization.city),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Tooltip(
              message: 'Send email',
              child: CircleAvatar(
                child: GestureDetector(
                  child: Icon(
                    Icons.alternate_email,
                    color: colorWhite,
                    size: 12,
                  ),
                  onTap: () => sendEmail(organization.email),
                ),
                radius: 12,
                backgroundColor: mainColor,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Tooltip(
              message: 'Call',
              child: CircleAvatar(
                child: GestureDetector(
                  child: Icon(
                    Icons.phone,
                    color: colorWhite,
                    size: 12,
                  ),
                  onTap: () => callPhone(organization.phoneNo),
                ),
                radius: 12,
                backgroundColor: mainColor,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Tooltip(
              message: 'Donate',
              child: CircleAvatar(
                child: GestureDetector(
                  child: Icon(
                    Icons.link,
                    color: colorWhite,
                    size: 12,
                  ),
                  onTap: () => _launchURL(context, organization.webLinks),
                ),
                radius: 12,
                backgroundColor: mainColor,
              ),
            ),
          ],
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              organization.description,
              textAlign: TextAlign.justify,
            ),
          )
        ],
        backgroundColor: colorWhite,
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

