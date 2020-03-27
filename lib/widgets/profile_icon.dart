import 'package:flutter/material.dart';
import 'package:project_hestia/Profile/profilePage.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/services/google_auth.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

enum Options {
  Profile,
  Logout,
}
resetVariables() async {
  final sp = SharedPrefsCustom();
  bool gauthUsed = await sp.getIfUsedGauth();
  if (gauthUsed != null) {
    if (gauthUsed) {
      signOutGoogle();
    }
  }
  sp.setLoggedInStatus(false);
  sp.setIfUsedGauth(false);
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'profile',
      child: Material(
        child: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          offset: Offset(0, 50),
          onSelected: (Options option) {
            if (option == Options.Profile) {
              //print("profile clicked");
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => ProfilePage()));
            } else if (option == Options.Logout) {
              print("logout clicked");
              resetVariables();
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
        ),
      ),
    );
  }
}
