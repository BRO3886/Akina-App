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

  Future<bool> getLoggedInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'logged-in';
    return prefs.getBool(key);
  }

  void setLoggedInStatus(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'logged-in';
    prefs.setBool(key, value);
    print("logged in cached");
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

  
  Future<bool> getShopStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'shop-status';
    return prefs.getBool(key);
  }

  void setShopStatus(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'shop-status';
    prefs.setBool(key, value);
  }

  Future<bool> getRequestStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'request-status';
    return prefs.getBool(key);
  }

  void setRequestStatus(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'request-status';
    prefs.setBool(key, value);
  }

  Future<int> getUserId() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final key = "user-id";
    return preferences.getInt(key);
  }

  void setUserId(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'user-id';
    prefs.setInt(key, value);
    print("id stored as "+value.toString());
  }


}
