import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:portal_phase_ii_ui/helpers.dart';

class NotificationItem extends StatefulWidget {
  final notifNo;
  const NotificationItem({Key? key, required this.notifNo}) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState(this.notifNo);
}

class _NotificationItemState extends State<NotificationItem> {
  var notifNo;
  var notification;
  var defaultNotification;
  bool isEditable = false;

  _NotificationItemState(this.notifNo);

  Future fetchDetails() async {
    final _accessToken = (await getUserCreds())['token'];
    var result = await http.get(
      Uri.parse(
          'http://192.168.1.8:3000/maintenance/notification-det?no=$notifNo'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
    );

    setState(() {
      notification =
          new Map<String, dynamic>.from(json.decode(result.body))['header'];
      // notification['NOTIF_NO'] = jsonResult['NOTIF_NO'];
      // notification['LOC_ACC'] = jsonResult['LOC_ACC'];
      // notification['EQUIPMENT'] = jsonResult['EQUIPMENT'];
      // notification['SHORT_TEXT'] = jsonResult['SHORT_TEXT'];
      // notification['STRMLFNDATE'] = jsonResult['STRMLFNDATE'];
      // notification['PRIORITY'] = jsonResult['PRIORITY'];
      // notification['REPORTEDBY'] = jsonResult['REPORTEDBY'];

      defaultNotification =
          new Map<String, dynamic>.from(json.decode(result.body))['header'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
    setState(() {});
  }

  onSubmit() {
    print(1);
    print(notification);
    print(2);
    print(defaultNotification);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Hero(
        tag: 'item$notifNo',
        child: Scaffold(
          appBar: AppBar(
            title: Text(notifNo),
            actions: [
              Visibility(
                visible: !isEditable,
                child: IconButton(
                  onPressed: () => setState(() {
                    isEditable = true;
                  }),
                  icon: Icon(Icons.edit),
                ),
              ),
              Visibility(
                visible: isEditable,
                child: IconButton(
                  onPressed: () {
                    onSubmit();
                    setState(() {
                      isEditable = false;
                    });
                  },
                  icon: Icon(
                    Icons.save,
                    color: Colors.green,
                  ),
                ),
              ),
              Visibility(
                visible: isEditable,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      notification = defaultNotification;
                      isEditable = false;
                    });
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          body: DefaultTextStyle.merge(
            style: TextStyle(color: Colors.grey[850]),
            child: Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        '${isEditable ? "Edit" : "View"} Notification Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                Text(
                                  'Notification No',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text('${int.parse(notification['NOTIF_NO'])}'),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Text(
                                  'Local Account',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text('${int.parse(notification['LOC_ACC'])}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Equipment ID',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text('${notification['EQUIPMENT']}'),
                      SizedBox(
                        height: 60,
                      ),
                      TextFormField(
                        initialValue: '${notification['SHORT_TEXT']}',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        onChanged: (val) => setState(() {
                          notification['SHORT_TEXT'] = val;
                        }),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Short Description',
                          labelStyle: new TextStyle(
                            color: const Color(0xFF424242),
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: isEditable
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue: '${notification['PRIORITY']}',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        onChanged: (val) => setState(() {
                          notification['PRIORITY'] = val;
                        }),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Priority',
                          labelStyle: new TextStyle(
                            color: const Color(0xFF424242),
                            fontWeight: FontWeight.w300,
                          ),
                          focusedBorder: isEditable
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                )
                              : null,
                          enabledBorder: isEditable
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue: '${notification['REPORTEDBY']}',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        onChanged: (val) => setState(() {
                          notification['REPORTEDBY'] = val;
                        }),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Reported By',
                          labelStyle: new TextStyle(
                            color: const Color(0xFF424242),
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: isEditable
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text("${notification['STRMLFNDATE']}"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
