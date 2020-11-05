import 'package:flutter/material.dart';

import 'package:clocktrol/time_display.dart';
import 'workday.dart';

class TrackPage extends StatelessWidget {
  const TrackPage(
    this._percentageMode,
    this._workday,
    this._setUpWorkday,
    this._stopOrContinueWorkday, {
    Key key,
  }) : super(key: key);

  final bool _percentageMode;
  final Workday _workday;
  final VoidCallback _setUpWorkday;
  final VoidCallback _stopOrContinueWorkday;

  @override
  Widget build(BuildContext context) {
    if (_workday == null) {
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
            'You haven\'t started your workday yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            _setUpWorkday();
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
            TimeDisplay('Start', _percentageMode, _workday.start,
                totalWorkday: _workday.totalWorkdayDuration),
            TimeDisplay('Breaks', _percentageMode, _workday.totalBreaksDuration,
                totalWorkday: _workday.totalWorkdayDuration),
            TimeDisplay('End', _percentageMode, _workday.end,
                totalWorkday: _workday.totalWorkdayDuration)
          ]),
          SizedBox(height: 50),
          TimeDisplay('Hours worked', _percentageMode, _workday.workedTime,
              totalWorkday: _workday.totalWorkdayDuration, size: 'l'),
          SizedBox(height: 50),
          _timeDisplayRow(<TimeDisplay>[
            TimeDisplay('tracked time', _percentageMode, _workday.trackedTime,
                totalWorkday: _workday.totalWorkdayDuration),
            TimeDisplay(
                'unproductive time', _percentageMode, _workday.unproductiveTime,
                totalWorkday: _workday.totalWorkdayDuration)
          ]),
          SizedBox(height: 50),
          RaisedButton(
            onPressed: () {
              _stopOrContinueWorkday();
            },
            child: Text(
              _workday.isPausedOrEnded ? 'Continue working' : 'Stop working',
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
