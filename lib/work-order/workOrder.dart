import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';

import 'package:portal_phase_ii_ui/helpers.dart';
import 'package:portal_phase_ii_ui/main.dart';

class WorkOrderWidget extends StatefulWidget {
  const WorkOrderWidget({Key? key}) : super(key: key);

  @override
  _WorkOrderWidgetState createState() => _WorkOrderWidgetState();
}

class _WorkOrderWidgetState extends State<WorkOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => SliverFab(
        floatingWidget: FloatingActionButton(
          onPressed: () => print('New Work Order'),
          child: Icon(Icons.add),
        ),
        floatingPosition: FloatingPosition(right: 16),
        expandedHeight: 200.0,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Work Orders",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
            ),
            actions: [
              Row(
                children: [
                  Text(
                    'Log Out',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      clearUserCreds();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                    icon: Icon(Icons.logout),
                    tooltip: 'Log Out',
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(child: Text('asdsad')),
                Container(child: Text('asdsad')),
                Container(child: Text('asdsad')),
                Container(child: Text('asdsad')),
                Container(child: Text('asdsad')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
