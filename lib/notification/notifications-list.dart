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
  var woResult;

  Future fetchList() async {
    final _accessToken = (await getUserCreds())['token'];
    var result = await http.get(
      Uri.parse('http://192.168.1.8:3000/maintenance/notification-list'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_accessToken',
      },
    );
    setState(() {
      woResult = json.decode(result.body);
    });
  }

  Future<List<dynamic>> fetchNOPRList() async {
    if (woResult == null || woResult?.isEmpty) await fetchList();
    var result = woResult['nopr']['item'];
    return result.sublist(0, result.length > 10 ? 11 : result.length);
  }

  Future<List<dynamic>> fetchOSNOList() async {
    var result = woResult['osno']['item'];
    return result.sublist(0, result.length > 10 ? 11 : result.length);
  }

  Future<List<dynamic>> fetchNOCOList() async {
    var result = woResult['noco']['item'];
    return result.sublist(0, result.length > 10 ? 11 : result.length);
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

  // showMenu() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(16.0),
  //               topRight: Radius.circular(16.0),
  //             ),
  //             color: Color(0xff232f34),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: <Widget>[
  //               Container(
  //                 height: 36,
  //               ),
  //               SizedBox(
  //                   height: (56 * 6).toDouble(),
  //                   child: Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(16.0),
  //                           topRight: Radius.circular(16.0),
  //                         ),
  //                         color: Color(0xff344955),
  //                       ),
  //                       child: Stack(
  //                         alignment: Alignment(0, 0),
  //                         overflow: Overflow.visible,
  //                         children: <Widget>[
  //                           Positioned(
  //                             top: -36,
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                   borderRadius:
  //                                       BorderRadius.all(Radius.circular(50)),
  //                                   border: Border.all(
  //                                       color: Color(0xff232f34), width: 10)),
  //                               child: Center(
  //                                 child: ClipOval(
  //                                   child: Icon(
  //                                     Icons.add_outlined,
  //                                     color: Colors.red,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Positioned(
  //                             child: ListView(
  //                               physics: NeverScrollableScrollPhysics(),
  //                               children: <Widget>[
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Inbox",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.inbox,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Starred",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.star_border,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Sent",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.send,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Trash",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.delete_outline,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Spam",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.error,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Drafts",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.mail_outline,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                               ],
  //                             ),
  //                           )
  //                         ],
  //                       ))),
  //               Container(
  //                 height: 56,
  //                 color: Color(0xff4a6572),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }
}
