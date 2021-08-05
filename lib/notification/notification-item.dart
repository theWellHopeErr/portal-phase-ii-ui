import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
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
  Map<String, dynamic> notification = {
    "NOTIF_NO": "0",
    "LOC_ACC": "0",
    "EQUIPMENT": "Loading...",
    "SHORT_TEXT": "Loading...",
    "STRMLFNDATE": DateFormat('dd-MM-yyyy').format(DateTime.now()),
    "PRIORITY": "Loading...",
    "REPORTEDBY": "Loading...",
  };
  var defaultNotification;
  bool isEditable = false;
  String error = '';
  String message = '';
  bool loading = false;

  final priorityController = TextEditingController();
  final shortDescController = TextEditingController();
  final reportedByController = TextEditingController();

  _NotificationItemState(this.notifNo);

  Future fetchDetails() async {
    final _accessToken = (await getUserCreds())['token'];
    var result = await http.get(
      Uri.parse(
          'http://$hostAddress:3000/maintenance/notification-det?no=$notifNo'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
    );

    setState(() {
      notification =
          new Map<String, dynamic>.from(json.decode(result.body))['header'];
      notification['STRMLFNDATE'] = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(notification['STRMLFNDATE']));

      priorityController.text = "${notification['PRIORITY']}";
      shortDescController.text = "${notification['SHORT_TEXT']}";
      reportedByController.text = "${notification['REPORTEDBY']}";

      defaultNotification =
          new Map<String, dynamic>.from(json.decode(result.body))['header'];
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != notification['STRMLFNDATE'])
      setState(() {
        notification['STRMLFNDATE'] = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
    setState(() {
      priorityController.text = "${notification['PRIORITY']}";
      shortDescController.text = "${notification['SHORT_TEXT']}";
      reportedByController.text = "${notification['REPORTEDBY']}";
    });
  }

  onSubmit() async {
    setState(() {
      loading = true;
      error = "";
      message = "";
      notification['PRIORITY'] = priorityController.text;
      notification['SHORT_TEXT'] = shortDescController.text;
      notification['REPORTEDBY'] = reportedByController.text;
    });

    if (notification['STRMLFNDATE'] is String) {
      var date = notification['STRMLFNDATE'].split('-');
      if (date[0].length == 2)
        notification['STRMLFNDATE'] = "${date[2]}-${date[1]}-${date[0]}";
    }

    final body = jsonEncode({
      "notif_no": notifNo,
      "equip_id": notification['EQUIPMENT'],
      "func_loc": notification['LOC_ACC'],
      "text": notification['SHORT_TEXT'],
      "start_mal_date": '${notification['STRMLFNDATE']}',
      "reported_by": notification['REPORTEDBY'],
      "priority": notification['PRIORITY']
    });

    print(body);

    final _accessToken = (await getUserCreds())['token'];

    var response = await http.put(
      Uri.parse('http://$hostAddress:3000/maintenance/notification'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      setState(() {
        message = "Updated Successfully.";
        error = "";
        loading = false;
      });
    } else {
      setState(() {
        message = "";
        error = "Error During Updation... Try again later.";
        loading = false;
      });
      throw Exception('Failed to update Notification.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Hero(
        tag: 'item$notifNo',
        child: Scaffold(
          appBar: AppBar(
            title: Text(notification['SHORT_TEXT'] == 'Loading...'
                ? notifNo
                : notification['SHORT_TEXT']),
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
                      priorityController.text = "${notification['PRIORITY']}";
                      shortDescController.text =
                          "${notification['SHORT_TEXT']}";
                      reportedByController.text =
                          "${notification['REPORTEDBY']}";
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
                      Visibility(
                        visible: loading,
                        child: CircularProgressIndicator(),
                      ),
                      Visibility(
                        visible: error.isNotEmpty,
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: message.isNotEmpty,
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            message.isNotEmpty || error.isNotEmpty || loading,
                        child: SizedBox(
                          height: 30,
                        ),
                      ),
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
                      Text(
                          '${isNumeric(notification['EQUIPMENT']) ? int.parse(notification['EQUIPMENT']) : notification['EQUIPMENT']}'),
                      SizedBox(
                        height: 60,
                      ),
                      TextField(
                        controller: shortDescController,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        readOnly: !isEditable,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Short Description',
                          labelStyle: TextStyle(
                            color: const Color(0xFF424242),
                            fontWeight: FontWeight.w500,
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
                      TextField(
                        controller: priorityController,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        readOnly: !isEditable,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Priority',
                          labelStyle: TextStyle(
                            color: const Color(0xFF424242),
                            fontWeight: FontWeight.w500,
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
                      TextField(
                        controller: reportedByController,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        readOnly: !isEditable,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Reported By',
                          labelStyle: TextStyle(
                            color: const Color(0xFF424242),
                            fontWeight: FontWeight.w500,
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
                      Row(
                        children: [
                          Text(
                            'Start Malfunction Date: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context),
                            child: Text(
                                '${notification['STRMLFNDATE']}'.split(' ')[0]),
                          ),
                        ],
                      ),
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
