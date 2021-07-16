import 'package:flutter/material.dart';

class NotificationCreate extends StatefulWidget {
  const NotificationCreate({Key? key}) : super(key: key);

  @override
  _NotificationCreateState createState() => _NotificationCreateState();
}

class _NotificationCreateState extends State<NotificationCreate> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Notification'),
        ),
        body: DefaultTextStyle.merge(
          style: TextStyle(color: Colors.grey[850]),
          child: Container(
            child: Text('Create Notification'),
            color: const Color(0xfff3f3f3),
            height: double.infinity,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
