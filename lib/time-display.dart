import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final String _title;
  DateTime _time;
  Duration _duration;
  bool _small;

  TimeDisplay(this._title, dynamic timeOrDuration, [bool small]) {
    if (timeOrDuration is DateTime) {
      _time = timeOrDuration;
    } else if (timeOrDuration is Duration) {
      _duration = timeOrDuration;
    } else if (timeOrDuration != null) {
      throw ArgumentError(
          'timeOrDuration parameter passed to TimeDisplay is not of DateTime nor of Duration type.');
    }
    _small = small == null ? true : small;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _small ? 120 : 300,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: _small ? 120 : 250,
              alignment: Alignment.center,
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _small ? 20 : 40,
                  color: Colors.grey,
                ),
              ),
            ),
            Text(
              _getString(),
              style: TextStyle(
                fontSize: _small ? 28 : 56,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ));
  }

  String _getString() {
    if (_time != null) {
      return '${_prependZero(_time.hour.toString())}:${_prependZero(_time.minute.toString())}';
    } else if (_duration != null) {
      return '${_duration.inHours.toString()}:${_prependZero((_duration.inMinutes % 60).toString())}';
    }
    return '--:--';
  }

  String _prependZero(String val) {
    if (val.length <= 1) return '0' + val;
    return val;
  }
}
