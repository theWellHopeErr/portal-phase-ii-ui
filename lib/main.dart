import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_phase_ii_ui/helpers.dart';

import 'package:portal_phase_ii_ui/home.dart';
import 'package:portal_phase_ii_ui/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'FCM',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF591EFF),
        primaryColorLight: Color(0xFF9977F9),
        primaryColorDark: Color(0xFF7B1FA2),
        accentColor: Color(0xFF9C27B0),
        scaffoldBackgroundColor: Color(0xFF7C4DFF),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Montserrat',
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LandingWidget(),
      ),
    );
  }
}

class LandingWidget extends StatefulWidget {
  const LandingWidget({Key? key}) : super(key: key);

  @override
  _LandingWidgetState createState() => _LandingWidgetState();
}

class _LandingWidgetState extends State<LandingWidget> {
  Map userCred = <String, String>{
    'token': '',
    'plant': 'SA01',
    'plantGroup': '010',
  };

  @override
  void initState() {
    super.initState();
    // clearUserCreds();
    getUserCreds().then((value) {
      print(value);
      setState(() {
        userCred = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: (() => userCred['token']!.isEmpty
            ? LoginWidget()
            : HomeWidget(
                plant: userCred['plant'],
                plantGroup: userCred['plantGroup'],
              ))(),
      ),
    );
  }
}
