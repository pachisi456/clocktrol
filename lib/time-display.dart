import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final String _title;
  DateTime _time;
  Duration _duration;
  String _size; // 's', 'm' or 'b'.

  TimeDisplay(this._title, dynamic timeOrDuration, [String size]) {
    if (timeOrDuration is DateTime) {
      _time = timeOrDuration;
    } else if (timeOrDuration is Duration) {
      _duration = timeOrDuration;
    } else if (timeOrDuration != null) {
      throw ArgumentError(
          'timeOrDuration parameter passed to TimeDisplay is not of DateTime nor of Duration type.');
    }
    _size = size == null ? 'm' : size;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _size == 's' ? 90 : _size == 'm' ? 117 : 300,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 5),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: _size == 's' ? 100 : _size == 'm' ? 120 : 250,
              alignment: Alignment.center,
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _size == 's' ? 16 : _size == 'm' ? 20 : 40,
                  color: Colors.grey,
                ),
              ),
            ),
            Text(
              _getString(),
              style: TextStyle(
                fontSize: _size == 's' ? 18 : _size == 'm' ? 28 : 56,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ));
  }

  String _getString() {
    // TODO Consider using DateFormat.
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
