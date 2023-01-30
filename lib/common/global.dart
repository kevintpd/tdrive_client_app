import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences prefs;
Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  var username = prefs.getString("username");
  if (username == null) {
    prefs.setString('username', '');
  }
  var token = prefs.getString("token");
  if (token == null) {
    prefs.setString('token', '');
  }
  var themeMode = prefs.getInt("themeMode");
  if (themeMode == null) {
    prefs.setInt('themeMode', 0);
  }
  var lastLogin = prefs.getString("lastLogin");
  if (lastLogin == null) {
    prefs.setString('lastLogin', '');
  }
}
