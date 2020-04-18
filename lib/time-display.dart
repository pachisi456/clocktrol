import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  String _title;
  DateTime _time;
  Duration _duration;

  TimeDisplay(String title, dynamic timeOrDuration) {
    _title = title;
    if (timeOrDuration is DateTime) {
      _time = timeOrDuration;
    } else if (timeOrDuration is Duration) {
      _duration = timeOrDuration;
    } else if (timeOrDuration != null) {
      throw ArgumentError(
          'timeOrDuration parameter passed to TimeDisplay is not of DateTime nor of Duration type.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 120,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            Text(
              _getString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ));
  }

  String _getString() {
    if (_time != null) {
      return '${_prependZero(_time.hour.toString())}:${_prependZero(_time.minute.toString())}';
    } else if (_duration != null) {
      return '${_prependZero(_duration.inHours.toString())}:${_prependZero((_duration.inMinutes % 60).toString())}';
    }
    return '--:--';
  }

  String _prependZero(String val) {
    if (val.length <= 1) return '0' + val;
    return val;
  }
}
