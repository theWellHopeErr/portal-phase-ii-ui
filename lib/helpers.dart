import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future getUserCreds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userCreds = prefs.getString('userCreds');
  if (userCreds != null) return jsonDecode('$userCreds');
  throw Exception('User Creds Not Found');
}

Future clearUserCreds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('userCreds');
}
