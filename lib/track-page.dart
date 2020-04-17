import 'package:clocktrol/time-display.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'workday.dart';

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  Workday _workday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clocktrol'),
      ),
      body: Center(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_workday == null) {
      return _buildPristine();
    } else {
      return _buildStarted();
    }
  }

  Widget _buildPristine() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
          _startWorkday();
        },
        child: Text(
          'Start workday now',
          style: TextStyle(fontSize: 26),
        ),
      ),
    ]);
  }

  Widget _buildStarted() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row( // TODO Make this a widget, as same thing is used below.
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TimeDisplay('Start', _workday.start),
            TimeDisplay('Breaks', _workday.totalBreaksDuration),
            TimeDisplay('End', _workday.end)
          ],
        ),
        SizedBox(height: 50),
        TimeDisplay('Hours worked', _workday.workedTime),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TimeDisplay('tracked time', _workday.trackedTime),
            TimeDisplay('unproductive time', _workday.unproductiveTime)
          ],
        ),
      ],
    ));
  }

  void _startWorkday() {
    setState(() {
      _workday = new Workday(DateTime.now());
    });
    // Timer.periodic(Duration(minutes: 1), (Timer t) => _setWorkingSince());
  }
}
