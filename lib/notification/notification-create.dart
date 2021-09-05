import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:portal_phase_ii_ui/helpers.dart';
import 'package:portal_phase_ii_ui/notification/notification-item.dart';

class NotificationCreate extends StatefulWidget {
  const NotificationCreate({Key? key}) : super(key: key);

  @override
  _NotificationCreateState createState() => _NotificationCreateState();
}

class _NotificationCreateState extends State<NotificationCreate> {
  final _formKey = GlobalKey<FormState>();
  late String error = '';
  late String message = '';
  late bool loading = false;
  final startMalDateController = TextEditingController();
  final reqStartDateController = TextEditingController();
  final reqEndDateController = TextEditingController();
  late int notificationNo = 0;
  Map<String, dynamic> formData = {
    "notif_type": "",
    "equip_id": "",
    "func_loc": "",
    "desc": "",
    "priority": "",
    "start_mal_date": "",
    "req_start_date": "",
    "req_end_date": "",
    "reported_by": "",
  };

  onSubmit() async {
    print(jsonEncode(formData));
    setState(() {
      loading = true;
      error = '';
      message = '';
    });

    final _accessToken = (await getUserCreds())['token'];

    var response = await http.post(
      Uri.parse('http://$hostAddress:3000/maintenance/notification'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
      body: jsonEncode(formData),
    );
    if (response.statusCode == 201) {
      setState(() {
        loading = false;
        error = '';
        notificationNo = int.parse(json.decode(response.body)['notif_no']);
        message = 'Notification Created With $notificationNo';
      });
      print(json.decode(response.body));
    } else {
      setState(() {
        loading = false;
        error = 'Error during Creation';
        message = '';
      });
      throw Exception('Failed to create Notification.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create New Notification'),
        ),
        body: DefaultTextStyle.merge(
          style: TextStyle(color: Colors.grey[850]),
          child: Container(
            color: const Color(0xfff3f3f3),
            height: double.infinity,
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Create New Notification',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Notification Type*',
                            labelStyle: TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Notification Type';
                          }
                          formData['notif_type'] = value;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Equipment No*',
                            labelStyle: TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Equipment No';
                          }
                          formData['equip_id'] = value;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Functional Location*',
                            labelStyle: TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Functional Location';
                          }
                          formData['func_loc'] = value;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description*',
                            labelStyle: TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Description';
                          }
                          formData['desc'] = value;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Priority*',
                            labelStyle: TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Priority';
                          }
                          formData['priority'] = value;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: startMalDateController,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Start Malfunction Date',
                          labelStyle: TextStyle(
                            color: const Color(0xFF424242),
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onTap: () async {
                          DateTime? date = DateTime(1900);
                          FocusScope.of(context).requestFocus(new FocusNode());
                          date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          setState(() {
                            formData['start_mal_date'] =
                                date!.toIso8601String().split('T')[0];
                            startMalDateController.text =
                                date.toIso8601String().split('T')[0];
                          });
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: reqStartDateController,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Request Start Date',
                          labelStyle: TextStyle(
                            color: const Color(0xFF424242),
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onTap: () async {
                          DateTime? date = DateTime(1900);
                          FocusScope.of(context).requestFocus(new FocusNode());
                          date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          setState(() {
                            formData['req_start_date'] =
                                date!.toIso8601String().split('T')[0];
                            reqStartDateController.text =
                                date.toIso8601String().split('T')[0];
                          });
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: reqEndDateController,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Request End Date',
                          labelStyle: TextStyle(
                            color: const Color(0xFF424242),
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onTap: () async {
                          DateTime? date = DateTime(1900);
                          FocusScope.of(context).requestFocus(new FocusNode());
                          date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          setState(() {
                            formData['req_end_date'] =
                                date!.toIso8601String().split('T')[0];
                            reqEndDateController.text =
                                date.toIso8601String().split('T')[0];
                          });
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Reported by*',
                            labelStyle: TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Reported by';
                          }
                          formData['reported_by'] = value;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                              visible: message.isNotEmpty ||
                                  error.isNotEmpty ||
                                  loading,
                              child: SizedBox(
                                height: 10,
                              ),
                            ),
                            Visibility(
                              visible: message.isNotEmpty,
                              child: MaterialButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotificationItem(
                                          notifNo: notificationNo.toString(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text('View Notification'),
                                height: 50,
                                minWidth: double.infinity,
                                color: Colors.white,
                                textColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: message.isNotEmpty ||
                                  error.isNotEmpty ||
                                  loading,
                              child: SizedBox(
                                height: 10,
                              ),
                            ),
                            Visibility(
                              visible: !loading,
                              child: MaterialButton(
                                onPressed: () {
                                  if (message.isEmpty) {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      onSubmit();
                                    }
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child:
                                    Text(message.isEmpty ? 'Submit' : 'Close'),
                                height: 50,
                                minWidth: double.infinity,
                                color: Colors.white,
                                textColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ],
                        ),
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
