import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:portal_phase_ii_ui/helpers.dart';

class WorkOrderItem extends StatefulWidget {
  final snapshot;
  final int index;
  const WorkOrderItem({Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  _WorkOrderItemState createState() =>
      _WorkOrderItemState(this.index, this.snapshot);
}

class _WorkOrderItemState extends State<WorkOrderItem> {
  final index;
  final snapshot;
  bool isEditable = false;
  bool loading = false;
  String error = '';
  String message = '';
  Map<String, dynamic> defaultWorkorder = {};
  Map<String, dynamic> workorder = {
    "ORDER_TYPE": "Loading...",
    "MN_WK_CTR": "Loading...",
    "MN_WKCTR_ID": "Loading...",
    "EQUIPMENT": "Loading...",
    "PRIORITY": "Loading...",
    "DESCRIPTION": "Loading...",
  };

  final priorityController = TextEditingController();
  final descController = TextEditingController();

  _WorkOrderItemState(this.index, this.snapshot);

  @override
  void initState() {
    super.initState();
    fetchDetails();
    setState(() {
      priorityController.text = "${workorder['PRIORITY']}";
      descController.text = "${workorder['DESCRIPTION']}";
    });
  }

  Future fetchDetails() async {
    final _accessToken = (await getUserCreds())['token'];
    var result = await http.get(
      Uri.parse(
          'http://$hostAddress:3000/maintenance/wo-det?wo=${snapshot.data[index]['ORDERID']}'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
    );

    var body = json.decode(result.body);
    setState(() {
      workorder['ORDER_TYPE'] = body['details']!['ORDER_TYPE'];
      workorder['EQUIPMENT'] = body['details']!['EQUIPMENT'];
      workorder['MN_WK_CTR'] = body['details']!['MN_WK_CTR'];
      workorder['MN_WKCTR_ID'] = body['details']!['MN_WKCTR_ID'];
      workorder['PRIORITY'] = body['details']!['PRIORITY'];
      workorder['DESCRIPTION'] = body['operations']!['item'] is List
          ? body['operations']!['item'][0]!['DESCRIPTION']
          : body['operations']!['item']['DESCRIPTION'];

      priorityController.text = "${workorder['PRIORITY']}";
      descController.text = "${workorder['DESCRIPTION']}";

      defaultWorkorder = workorder;
    });
  }

  onSubmit() async {
    setState(() {
      loading = true;
      error = "";
      message = "";
      workorder['PRIORITY'] = priorityController.text;
      workorder['DESCRIPTION'] = descController.text;
    });

    final body = jsonEncode({
      "order_id": snapshot.data[index]['ORDERID'],
      "order_type": workorder['ORDER_TYPE'],
      "equip_id": workorder['EQUIPMENT'],
      "priority": workorder['PRIORITY'],
      "opr_desc": workorder['DESCRIPTION'],
    });

    print(body);

    final _accessToken = (await getUserCreds())['token'];

    var response = await http.put(
      Uri.parse('http://$hostAddress:3000/maintenance/work-order'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
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
      throw Exception('Failed to update workorder.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Hero(
        tag: 'item$index',
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data[index]['DESCRIPTION']),
            actions: [
              Visibility(
                visible:
                    !isEditable && snapshot.data[index]['S_STATUS'] == 'CRTD',
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
                      workorder = defaultWorkorder;
                      priorityController.text = "${workorder['PRIORITY']}";
                      descController.text = "${workorder['DESCRIPTION']}";
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
                        '${isEditable ? "Edit" : "View"} workorder Details',
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
                                  'Work Order No',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                    '${int.parse(snapshot.data[index]['ORDERID'])}'),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Text(
                                  'Order Type',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(workorder['ORDER_TYPE']),
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
                          '${isNumeric(workorder['EQUIPMENT']) ? int.parse(workorder['EQUIPMENT']) : workorder['EQUIPMENT']}'),
                      SizedBox(
                        height: 60,
                      ),
                      TextField(
                        controller: descController,
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
                      TextFormField(
                        initialValue: snapshot.data[index]['PRIOTYPE'],
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        readOnly: !isEditable,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Priority Type',
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
                      TextFormField(
                        initialValue: snapshot.data[index]['WORK_CNTR'],
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        readOnly: !isEditable,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Work Center',
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
