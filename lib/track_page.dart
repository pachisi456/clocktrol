import 'package:flutter/material.dart';
import 'dart:async';

import 'package:clocktrol/time_display.dart';
import 'workday.dart';
import 'firebase.dart';

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  final ClocktrolStore _store = ClocktrolStore(); // TODO Remove when moved to main.dart.

  Workday _workday;

  @override
  void initState() {
    _store.getToday().then((Workday today) {
      if (today != null) {
        _setUpWorkday(today);
      }
    });
    super.initState();
  }

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
            'You haven\'t started your worday yet.',
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
            TimeDisplay('Start', _workday.start),
            TimeDisplay('Breaks', _workday.totalBreaksDuration),
            TimeDisplay('End', _workday.end)
          ]),
          SizedBox(height: 50),
          TimeDisplay('Hours worked', _workday.workedTime, 'l'),
          SizedBox(height: 50),
          _timeDisplayRow(<TimeDisplay>[
            TimeDisplay('tracked time', _workday.trackedTime),
            TimeDisplay('unproductive time', _workday.unproductiveTime)
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

  void _setUpWorkday([Workday today]) {
    setState(() {
      if (today == null) {
        _workday = _store.startNewDay();
      } else {
        _workday = today;
      }
    });
    Timer.periodic(Duration(seconds: 2), (Timer t) => _updateData());
  }

  void _stopOrContinueWorkday() {
    if (!_workday.isPausedOrEnded) {
      // Assume workday is ended.
      _workday.end = DateTime.now();
    } else {
      // Add break, from end to now and reset end.
      _workday.breaks.add(Break(_workday.end, DateTime.now()));
      _workday.end = null;
    }
    _updateData();
  }

  void _updateData() {
    _store.updateToday(_workday);
    setState(() {});
  }
}
