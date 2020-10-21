import 'package:flutter/material.dart';

import 'package:clocktrol/time_display.dart';
import 'workday.dart';

class TrackPage extends StatelessWidget {
  const TrackPage({
    Key key,
    this.history,
    this.workday,
    this.setUpWorkday,
    this.stopOrContinueWorkday,
  }) : super(key: key);

  final List<Workday> history;
  final Workday workday;
  final VoidCallback setUpWorkday;
  final VoidCallback stopOrContinueWorkday;

  @override
  Widget build(BuildContext context) {
    if (workday == null) {
      return _buildPristine();
    } else {
      return _buildStarted();
    }
  }

  Widget _buildPristine() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'You haven\'t started your worday yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            setUpWorkday();
          },
          child: Text(
            'Start workday now',
            style: TextStyle(fontSize: 26),
          ),
        ),
      ],
    );
  }

  Widget _buildStarted() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _timeDisplayRow(<TimeDisplay>[
            TimeDisplay('Start', workday.start),
            TimeDisplay('Breaks', workday.totalBreaksDuration),
            TimeDisplay('End', workday.end)
          ]),
          SizedBox(height: 50),
          TimeDisplay('Hours worked', workday.workedTime, 'l'),
          SizedBox(height: 50),
          _timeDisplayRow(<TimeDisplay>[
            TimeDisplay('tracked time', workday.trackedTime),
            TimeDisplay('unproductive time', workday.unproductiveTime)
          ]),
          SizedBox(height: 50),
          RaisedButton(
            onPressed: () {
              stopOrContinueWorkday();
            },
            child: Text(
              workday.isPausedOrEnded ? 'Continue working' : 'Stop working',
              style: TextStyle(fontSize: 26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeDisplayRow(List<TimeDisplay> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: children,
    );
  }
}