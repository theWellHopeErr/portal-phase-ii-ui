import 'package:flutter/material.dart';

class WorkOrderCreate extends StatefulWidget {
  const WorkOrderCreate({Key? key}) : super(key: key);

  @override
  _WorkOrderCreateState createState() => _WorkOrderCreateState();
}

class _WorkOrderCreateState extends State<WorkOrderCreate> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Work Order'),
        ),
        body: DefaultTextStyle.merge(
          style: TextStyle(color: Colors.grey[850]),
          child: Container(
            child: Text('Create Work Order'),
            color: const Color(0xfff3f3f3),
            height: double.infinity,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
