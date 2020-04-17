import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  String _title;
  DateTime _time;
  Duration _duration;

  TimeDisplay(String title, dynamic timeOrDuration) {
    this._title = title;
    if (timeOrDuration is DateTime) {
      this._time = timeOrDuration;
    } else if (timeOrDuration is Duration) {
      this._duration = timeOrDuration;
    } else {
      throw ArgumentError(
          '`timeOrDuration` parameter passed to TimeDisplay is not of DateTime nor of Duration type.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          _title,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
        Text(
          _getString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  String _getString() {
    if (_time != null) {
      return '${_prependZero(_time.hour.toString())}:${_prependZero(_time.minute.toString())}';
    } else if (_duration != null) {
      // TODO implement duration string.
    }
    return '00:00';
  }

  String _prependZero(String val) {
    if (val.length <= 1) return '0' + val;
    return val;
  }
}
