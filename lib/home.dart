import 'package:flutter/material.dart';
import 'package:portal_phase_ii_ui/Notification/notification.dart';
import 'package:portal_phase_ii_ui/work-order/WorkOrder.dart';

class HomeWidget extends StatefulWidget {
  final String plant;
  final String plantGroup;
  const HomeWidget({Key? key, required this.plant, required this.plantGroup})
      : super(key: key);

  @override
  _HomeWidgetState createState() =>
      _HomeWidgetState(this.plant, this.plantGroup);
}

class _HomeWidgetState extends State<HomeWidget> {
  final String plant;
  final String plantGroup;

  _HomeWidgetState(this.plant, this.plantGroup);

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    WorkOrderWidget(),
    NotificationWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DefaultTextStyle.merge(
          style: TextStyle(color: Colors.grey[850]),
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Work Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}