import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sliver_fab/sliver_fab.dart';
import 'dart:convert';
import 'dart:io';

import 'package:portal_phase_ii_ui/work-order/workorder-create.dart';
import 'package:portal_phase_ii_ui/work-order/workorder-list-item.dart';
import 'package:portal_phase_ii_ui/helpers.dart';
import 'package:portal_phase_ii_ui/main.dart';

class WorkOrderListWidget extends StatefulWidget {
  const WorkOrderListWidget({Key? key}) : super(key: key);

  @override
  _WorkOrderListWidgetState createState() => _WorkOrderListWidgetState();
}

class _WorkOrderListWidgetState extends State<WorkOrderListWidget> {
  var woResult;

  Future fetchList() async {
    final _accessToken = (await getUserCreds())['token'];
    var result = await http.get(
      Uri.parse('http://192.168.1.8:3000/maintenance/wo-list'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
    );
    setState(() {
      woResult = json.decode(result.body);
    });
  }

  Future<List<dynamic>> fetchRELList() async {
    if (woResult == null || woResult?.isEmpty) await fetchList();
    var result = woResult['rel']['item'];
    return result.sublist(0, result.length > 10 ? 11 : result.length);
  }

  Future<List<dynamic>> fetchCRTDList() async {
    var result = woResult['crtd']['item'];
    return result.sublist(0, result.length > 10 ? 11 : result.length);
  }

  Future<List<dynamic>> fetchTECOList() async {
    var result = woResult['teco']['item'];
    return result.sublist(0, result.length > 10 ? 11 : result.length);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: Builder(
        builder: (context) => SliverFab(
          floatingWidget: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkOrderCreate()),
            ),
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
                  SizedBox(height: 20.0),
                  ExpansionTile(
                    textColor: Colors.amber[900],
                    initiallyExpanded: true,
                    iconColor: Colors.amber[900],
                    collapsedTextColor: Colors.amber,
                    collapsedIconColor: Colors.amber,
                    title: Text(
                      'Released (REL)',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: fetchRELList(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(8),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return WorkOrderListItem(
                                    snapshot: snapshot, index: index);
                              },
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text(
                              'Something went wrong!',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            );
                          } else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        },
                      )
                    ],
                  ),
                  ExpansionTile(
                    textColor: Colors.red[900],
                    iconColor: Colors.red[900],
                    collapsedTextColor: Colors.red,
                    collapsedIconColor: Colors.red,
                    title: Text(
                      'Created (CRTD)',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: fetchCRTDList(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(8),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return WorkOrderListItem(
                                    snapshot: snapshot, index: index);
                              },
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text(
                              'Something went wrong!',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            );
                          } else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        },
                      )
                    ],
                  ),
                  ExpansionTile(
                    textColor: Colors.green[900],
                    iconColor: Colors.green[900],
                    collapsedTextColor: Colors.green,
                    collapsedIconColor: Colors.green,
                    title: Text(
                      'Completed (TECO)',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: fetchTECOList(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(8),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return WorkOrderListItem(
                                    snapshot: snapshot, index: index);
                              },
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text(
                              'Something went wrong!',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            );
                          } else
                            return CircularProgressIndicator();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
