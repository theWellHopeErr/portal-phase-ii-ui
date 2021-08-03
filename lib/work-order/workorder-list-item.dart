import 'package:flutter/material.dart';

import 'package:portal_phase_ii_ui/helpers.dart';
import 'package:portal_phase_ii_ui/work-order/workorder-item.dart';

class WorkOrderListItem extends StatelessWidget {
  final snapshot;
  final int index;
  const WorkOrderListItem(
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
                  return WorkOrderItem(snapshot: snapshot, index: index);
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
                        "${int.parse(snapshot.data[index]['ORDERID'])}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        snapshot.data[index]['WORK_CNTR'].toUpperCase(),
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
                            snapshot.data[index]['DESCRIPTION'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            snapshot.data[index]['EARL_SCHED_FINISH_DATE'],
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
                        "${int.parse(snapshot.data[index]['ACTIVITY'])}",
                        style: TextStyle(
                          fontSize: 11,
                          color: getPriorityColor(snapshot.data[index]['P']),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${snapshot.data[index]['WORK_ACTIVITY']} Hrs',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: getWorkActivityColor(
                              snapshot.data[index]['S_STATUS']),
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
