import 'package:clocktrol/time-display.dart';
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
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat.yMMMMEEEEd().format(history[index].start) +
                    ', ' +
                    DateFormat.Hm().format(history[index].start) +
                    ' - ' +
                    DateFormat.Hm().format(history[index].end),
              ),
              Row(
                children: <Widget>[
                  TimeDisplay('Breaks', history[index].totalBreaksDuration, 's'),
                  TimeDisplay('Tracked Time', history[index].trackedTime, 's'),
                  TimeDisplay('Unproductive Time', history[index].unproductiveTime, 's'),
                  TimeDisplay('Worked Time', history[index].workedTime, 's'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
