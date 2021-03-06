import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:portal_phase_ii_ui/helpers.dart';

class WorkOrderCreate extends StatefulWidget {
  const WorkOrderCreate({Key? key}) : super(key: key);

  @override
  _WorkOrderCreateState createState() => _WorkOrderCreateState();
}

class _WorkOrderCreateState extends State<WorkOrderCreate> {
  final _formKey = GlobalKey<FormState>();
  late String error = '';
  late String message = '';
  late bool loading = false;
  late int workOrderNo = 0;
  Map<String, dynamic> formData = {
    "notif_type": "",
    "equip_id": "",
    "order_type": "",
    "desc": "",
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
      Uri.parse('http://$hostAddress:3000/maintenance/work-order'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
      body: jsonEncode(formData),
    );

    if (response.statusCode == 201) {
      var responseMessage = json.decode(response.body)['message'];
      setState(() {
        loading = false;
        error = '';
        workOrderNo = int.parse(
            responseMessage[responseMessage.length - 2].split(' ')[5]);
        message = 'Work Order Created With $workOrderNo';
      });
      print(json.decode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var fcmToken = prefs.getString('fcmToken');
      var fcmResponse = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader:
              'key=AAAAtIuOlak:APA91bFdsvYpCO8vOQDzhQTbu7X8Zj_XPZLcN_8dK_3EKuKZ_J02EiwVvABOFXb4wskjya2xOjk6VwxUhtqznShbGYub3IMfEMlfvTAWN7AVe9TkArsliScpGYZ84rIFh1aK4IIRK-S4',
        },
        body: jsonEncode({
          "to": "$fcmToken",
          "notification": {
            "title": "New Work Order created",
            "body": "Work Order No: $workOrderNo"
          }
        }),
      );
      if (fcmResponse.statusCode == 200) {
      } else {
        throw Exception('Error in FCM.');
      }
    } else {
      setState(() {
        loading = false;
        error =
            'Error during Creation\n${json.decode(response.body)['message'][1]}';
        message = '';
      });
      throw Exception('Failed to create Work Order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create new Work Order'),
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
                        'Create new Work Order',
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
                            labelText: 'Order Type*',
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
                            return 'Please enter Order Type';
                          }
                          formData['order_type'] = value.toUpperCase();
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
                            labelText: 'Notification No',
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
                            formData['notif_no'] = null;
                          }
                          formData['notif_no'] = value;
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
                          labelText: 'Notification Type',
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            formData['notif_type'] = null;
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
                          formData['equip_id'] = value.toUpperCase();
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
