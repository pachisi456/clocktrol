import 'package:clocktrol/time_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'workday.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage(this._percentageMode, this._history, {Key key})
      : super(key: key);

  final List<Workday> _history;
  final bool _percentageMode;

  @override
  Widget build(BuildContext context) {
    return _history == null || _history.length <= 0
        ? Container(child: Text('No items.'))
        : ListView.separated(
            separatorBuilder: (context, index) => Divider(
              indent: 15,
              endIndent: 15,
              thickness: 1,
            ),
            itemCount: _history.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _historyRow(_history[index]),
                ),
              );
            },
          );
  }

  List<Widget> _historyRow(Workday workday) {
    return <Widget>[
      Text(
        DateFormat.yMMMMEEEEd().format(workday.start) +
            ', ' +
            DateFormat.Hm().format(workday.start) +
            ' - ' +
            DateFormat.Hm().format(workday.end) +
            ' (' +
            workday.totalWorkdayDuration.inHours.toString() +
            ':' +
            (workday.totalWorkdayDuration.inMinutes % 60).toString() +
            'h)',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TimeDisplay('Total Breaks', _percentageMode,
              workday.totalBreaksDuration, 's'),
          TimeDisplay(
              'Tracked Time', _percentageMode, workday.trackedTime, 's'),
          TimeDisplay(
              'Unprod. Time', _percentageMode, workday.unproductiveTime, 's'),
          TimeDisplay('Worked Time', _percentageMode, workday.workedTime, 's'),
        ],
      ),
    ];
  }
}
