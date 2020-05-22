import 'package:clocktrol/time_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'workday.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key key,
    this.history,
  }) : super(key: key);

  final List<Workday> history;

  @override
  Widget build(BuildContext context) {
    return history == null || history.length <= 0
        ? Container(child: Text('No items.'))
        : ListView.separated(
            separatorBuilder: (context, index) => Divider(
              indent: 15,
              endIndent: 15,
              thickness: 1,
            ),
            itemCount: history.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      DateFormat.yMMMMEEEEd().format(history[index].start) +
                          ', ' +
                          DateFormat.Hm().format(history[index].start) +
                          ' - ' +
                          DateFormat.Hm().format(history[index].end) +
                          ' (' +
                          history[index]
                              .totalWorkdayDuration
                              .inHours
                              .toString() +
                          ':' +
                          (history[index].totalWorkdayDuration.inMinutes % 60)
                              .toString() +
                          'h)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TimeDisplay('Total Breaks',
                            history[index].totalBreaksDuration, 's'),
                        TimeDisplay(
                            'Tracked Time', history[index].trackedTime, 's'),
                        TimeDisplay('Unprod. Time',
                            history[index].unproductiveTime, 's'),
                        TimeDisplay(
                            'Worked Time', history[index].workedTime, 's'),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }
}
