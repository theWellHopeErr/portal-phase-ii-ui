import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    print('Plant: $plant \nPlant Group: $plantGroup');
    return Container(child: Text('Home'));
  }
}
