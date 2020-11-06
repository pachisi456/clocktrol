import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  TimeDisplay(
    this._title,
    percentageMode,
    dynamic timeOrDuration, {
    @required Duration this.totalWorkday,
    String size,
  }) {
    if (timeOrDuration is DateTime) {
      _time = timeOrDuration;
    } else if (timeOrDuration is Duration) {
      _duration = timeOrDuration;
    } else if (timeOrDuration != null) {
      throw ArgumentError(
          'timeOrDuration parameter passed to TimeDisplay is not of DateTime nor of Duration type.');
    }

    // Sanity check for percentage mode, otherwise fall back to displaying time.
    if (percentageMode && totalWorkday != null && _duration != null) {
      _percentageMode = percentageMode;
    } else {
      _percentageMode = false;
    }

    _size = size == null ? 'm' : size;
  }

  final String _title;
  bool _percentageMode;
  final Duration totalWorkday; // Just needed if _percentageMode == true.
  DateTime _time;
  Duration _duration;
  String _size; // 's', 'm' or 'l'.

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _size == 's' ? 73 : _size == 'm' ? 117 : 300,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 5),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: _size == 's' ? 83 : _size == 'm' ? 120 : 250,
              alignment: Alignment.center,
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _size == 's' ? 14 : _size == 'm' ? 20 : 40,
                  color: Colors.grey,
                ),
              ),
            ),
            Text(
              _percentageMode ? _buildPercentageString() : _buildTimeString(),
              style: TextStyle(
                fontSize: _size == 's' ? 18 : _size == 'm' ? 28 : 56,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ));
  }

  String _buildTimeString() {
    // TODO Consider using DateFormat.
    if (_time != null) {
      return '${_prependZero(_time.hour.toString())}:${_prependZero(_time.minute.toString())}';
    } else if (_duration != null) {
      return '${_duration.inHours.toString()}:${_prependZero((_duration.inMinutes % 60).toString())}';
    }
    return '--:--';
  }

  String _buildPercentageString() {
    int totalWorkdaySeconds = totalWorkday.inSeconds > 0
        ? totalWorkday.inSeconds
        : 1; // Prevent division by zero.
    int percentage = (_duration.inSeconds / totalWorkdaySeconds * 100).round();
    return '${percentage.toString()}%';
  }

  String _prependZero(String val) {
    if (val.length <= 1) return '0' + val;
    return val;
  }
}
