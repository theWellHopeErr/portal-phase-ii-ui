import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:portal_phase_ii_ui/notification/notifications-list.dart';
import 'package:portal_phase_ii_ui/work-order/workorders-list.dart';

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

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
  late final FirebaseMessaging _messaging;
  late int _notificationNotifCount;
  late int _workorderNotifCount;
  PushNotification? _notificationInfo;

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

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    print("FCM Token: ${await _messaging.getToken()}");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          if (notification.title!.contains('Notification'))
            _notificationNotifCount++;
          if (notification.title!.contains('Work Order'))
            _workorderNotifCount++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(
                totalNotifications: notification.title!.contains('Work Order')
                    ? _workorderNotifCount
                    : _notificationNotifCount),
            slideDismissDirection: DismissDirection.horizontal,
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.blueAccent,
            foreground: Colors.white,
            duration: Duration(seconds: 5),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        if (notification.title!.contains('Notification'))
          _notificationNotifCount++;
        if (notification.title!.contains('Work Order')) _workorderNotifCount++;
      });
    }
  }

  @override
  void initState() {
    _notificationNotifCount = 0;

    _workorderNotifCount = 0;
    registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        if (notification.title!.contains('Notification'))
          _notificationNotifCount++;
        if (notification.title!.contains('Work Order')) _workorderNotifCount++;
      });
    });

    super.initState();
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
            icon: Stack(
              children: <Widget>[
                Icon(
                  Icons.receipt_long,
                  size: 30,
                ),
                Visibility(
                  visible: _workorderNotifCount != 0,
                  child: Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        '$_workorderNotifCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
            label: 'Work Orders',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: <Widget>[
                Icon(
                  Icons.campaign,
                  size: 30,
                ),
                Visibility(
                  visible: _notificationNotifCount != 0,
                  child: Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        '$_notificationNotifCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
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

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
