import 'package:flutter/material.dart';

import 'package:portal_phase_ii_ui/helpers.dart';
import 'package:portal_phase_ii_ui/notification/notification-edit.dart';

class NotificationItem extends StatelessWidget {
  final snapshot;
  final int index;
  const NotificationItem(
      {Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'item:$index',
      child: Card(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return NotificationEdit(snapshot: snapshot, index: index);
                },
              ),
            );
          },
          child: DefaultTextStyle.merge(
            style: TextStyle(color: Colors.grey[850]),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data[index]['NOTIFICAT'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        snapshot.data[index]['NOTIF_TYPE'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data[index]['DESCRIPT'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            snapshot.data[index]['NOTIFDATE'],
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        snapshot.data[index]['PR'],
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        getPriority(snapshot.data[index]['P']),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: getPriorityColor(snapshot.data[index]['P']),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
