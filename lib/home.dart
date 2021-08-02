import 'package:flutter/material.dart';
import 'package:portal_phase_ii_ui/notification/notifications-list.dart';
import 'package:portal_phase_ii_ui/work-order/workorders-list.dart';

class HomeWidget extends StatefulWidget {
  final String plant;
  final String planGroup;
  const HomeWidget({Key? key, required this.plant, required this.planGroup})
      : super(key: key);

  @override
  _HomeWidgetState createState() =>
      _HomeWidgetState(this.plant, this.planGroup);
}

class _HomeWidgetState extends State<HomeWidget> {
  final String plant;
  final String planGroup;

  _HomeWidgetState(this.plant, this.planGroup);

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    WorkOrderListWidget(),
    NotificationsListWidget(),
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
            color: const Color(0xfff3f3f3),
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
