import 'package:flutter/material.dart';

class NotificationEdit extends StatefulWidget {
  final snapshot;
  final int index;
  const NotificationEdit(
      {Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  _NotificationEditState createState() =>
      _NotificationEditState(this.index, this.snapshot);
}

class _NotificationEditState extends State<NotificationEdit> {
  final index;
  final snapshot;

  _NotificationEditState(this.index, this.snapshot);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Hero(
        tag: 'item$index',
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data[index]['NOTIFICAT']),
          ),
          body: DefaultTextStyle.merge(
            style: TextStyle(color: Colors.grey[850]),
            child: Container(
              child: Text(snapshot.data[index]['NOTIFICAT'],
                  style: TextStyle(color: Colors.black)),
              color: const Color(0xfff3f3f3),
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
