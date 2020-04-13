import 'package:flutter/material.dart';
import 'dart:async';

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  DateTime _start;
  String _workingSince;

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
    if (_start == null) {
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
    return Column(children: <Widget>[
      Text(
        'Workday started at ${_prependZero(_start.hour.toString())}:${_prependZero(_start.minute.toString())}',
        style: TextStyle(fontSize: 20),
      ),
      Text(
        '$_workingSince\nHours in...',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      )
    ]);
  }

  void _startWorkday() {
    setState(() {
      _start = DateTime.now();
    });
    Timer.periodic(Duration(minutes: 1), (Timer t) => _setWorkingSince());
  }

  void _setWorkingSince() {
    setState(() {
      // _start = DateTime.now()
          // .subtract(Duration(hours: 2, minutes: 2, seconds: 5)); // TODO Remove.
      var duration = DateTime.now().difference(_start);
      var hours = duration.inHours.toString();
      var minutes = (duration.inMinutes % 60).toString();
      _workingSince = _prependZero(hours) + ':' + _prependZero(minutes);
    });
  }

  String _prependZero(String val) {
    if (val.length <= 1) return '0' + val;
    return val;
  }
}
