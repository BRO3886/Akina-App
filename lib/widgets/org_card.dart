import 'package:flutter/material.dart';
import 'package:project_hestia/model/orgs.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/call_mail_web.dart';
import 'package:project_hestia/services/url_launcher.dart';

class OrganizationCard extends StatelessWidget {
  final Organization organization;
  OrganizationCard(this.organization);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                    size: 15,
                  ),
                  onTap: () => sendEmail(organization.email),
                ),
                radius: 15,
                backgroundColor: mainColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Tooltip(
              message: 'Call',
              child: CircleAvatar(
                child: GestureDetector(
                  child: Icon(
                    Icons.phone,
                    color: colorWhite,
                    size: 15,
                  ),
                  onTap: () => callPhone(organization.phoneNo),
                ),
                radius: 15,
                backgroundColor: mainColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Tooltip(
              message: 'Donate',
              child: CircleAvatar(
                child: GestureDetector(
                  child: Icon(
                    Icons.link,
                    color: colorWhite,
                    size: 15,
                  ),
                  onTap: () => launchURL(context, organization.webLinks),
                ),
                radius: 15,
                backgroundColor: mainColor,
              ),
            ),
          ],
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(
              organization.description,
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.justify,
            ),
          )
        ],
        backgroundColor: colorWhite,
      ),
    );
  }
}

