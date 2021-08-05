import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const hostAddress = "192.168.42.142";

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

String getPriority(String val) {
  switch (val) {
    case '1':
      return 'Very High';
    case '2':
      return 'High';
    case '3':
      return 'Medium';
    case '4':
      return 'Low';
    default:
      return 'Whenever';
  }
}

dynamic getPriorityColor(String val) {
  switch (val) {
    case '1':
      return Colors.red;
    case '2':
      return Colors.orange;
    case '3':
      return Colors.yellow;
    case '4':
      return Colors.green;
    default:
      return Colors.black;
  }
}

dynamic getWorkActivityColor(String val) {
  switch (val) {
    case 'CRTD':
      return Colors.orange;
    case 'TECO':
      return Colors.green;
    default:
      return Colors.red;
  }
}

bool isNumeric(String str) {
  try {
    int.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}
