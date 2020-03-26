import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsCustom {
  Future<String> getUserEmail() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final key = "email";
    return preferences.getString(key);
  }

  void setUserEmail(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'email';
    prefs.setString(key, value);
    print("email stored");
  }

  Future<String> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'name';
    return prefs.getString(key);
  }

  void setUserName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'name';
    prefs.setString(key, value);
    print("name stored");
  }

  Future<String> getPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'phone';
    return prefs.getString(key);
  }

  void setPhone(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'phone';
    prefs.setString(key, value);
    print("phone stored");
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'token';
    return prefs.getString(key);
  }

  void setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'token';
    prefs.setString(key, value);
    print("token stored");
  }

  Future<bool> getIfUsedGauth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'google-auth';
    return prefs.getBool(key);
  }

  void setIfUsedGauth(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'google-auth';
    prefs.setBool(key, value);
    print("used google auth, stored");
  }


}
