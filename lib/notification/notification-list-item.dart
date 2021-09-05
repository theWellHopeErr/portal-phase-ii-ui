import 'package:flutter/material.dart';

import 'package:portal_phase_ii_ui/helpers.dart';
import 'package:portal_phase_ii_ui/notification/notification-item.dart';

class NotificationListItem extends StatelessWidget {
  final snapshot;
  final int index;
  const NotificationListItem(
      {Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'item:${snapshot.data[index]['NOTIFICAT']}',
      child: Card(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            if (!snapshot.data[index]['S_STATUS']
                .toLowerCase()
                .contains('noco'))
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return NotificationItem(
                      notifNo:
                          "${int.parse(snapshot.data[index]['NOTIFICAT'])}",
                    );
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
                        "${int.parse(snapshot.data[index]['NOTIFICAT'])}",
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
                            snapshot.data[index]['DESCRIPT'].toString(),
                            overflow: TextOverflow.ellipsis,
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
                        snapshot.data[index]['PRIOTYPE'],
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        getPriority("${snapshot.data[index]['PRIORITY']}"),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: getPriorityColor(
                              '${snapshot.data[index]['PRIORITY']}'),
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
