import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sliver_fab/sliver_fab.dart';
import 'dart:convert';
import 'dart:io';

import 'package:portal_phase_ii_ui/notification/notification-create.dart';
import 'package:portal_phase_ii_ui/notification/notification-list-item.dart';
import 'package:portal_phase_ii_ui/helpers.dart';
import 'package:portal_phase_ii_ui/main.dart';

class NotificationsListWidget extends StatefulWidget {
  const NotificationsListWidget({Key? key}) : super(key: key);

  @override
  _NotificationsListWidgetState createState() =>
      _NotificationsListWidgetState();
}

class _NotificationsListWidgetState extends State<NotificationsListWidget> {
  var notifResult;

  Future fetchList() async {
    final _accessToken = (await getUserCreds())['token'];
    var result = await http.get(
      Uri.parse('http://$hostAddress:3000/maintenance/notification-list'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
    );
    setState(() {
      notifResult = json.decode(result.body);
    });
  }

  Future<List<dynamic>> fetchNOPRList() async {
    if (notifResult == null || notifResult?.isEmpty) await fetchList();
    var result = notifResult['nopr']['item'];
    return result.sublist(0, result.length > 10 ? 11 : result.length);
  }

  Future<List<dynamic>> fetchOSNOList() async {
    var result = notifResult['osno']['item'];
    return result.sublist(0, result.length > 10 ? 11 : result.length);
  }

  Future<List<dynamic>> fetchNOCOList() async {
    var result = notifResult['noco']['item'];
    return result.sublist(0, result.length > 10 ? 11 : result.length);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: Builder(
        builder: (context) => SliverFab(
          floatingWidget: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationCreate()),
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
                  "Notifications",
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
                    initiallyExpanded: true,
                    textColor: Colors.amber[900],
                    iconColor: Colors.amber[900],
                    collapsedTextColor: Colors.amber,
                    collapsedIconColor: Colors.amber,
                    title: Text(
                      'In Progress (NOPR)',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: fetchNOPRList(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(8),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return NotificationListItem(
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
                      'Pending (OSNO)',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: fetchOSNOList(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(8),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return NotificationListItem(
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
                      'Completed (NOCO)',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: fetchNOCOList(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(8),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return NotificationListItem(
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
