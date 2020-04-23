import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:clocktrol/clockify.dart';

class Workday {
  DateTime start, end;
  List<Break> breaks = [];
  final clockify = DotEnv().env['CLOCKIFY_API_KEY'] != null
      ? Clockify(DotEnv().env['CLOCKIFY_API_KEY'])
      : null;
  Duration trackedTime = Duration();

  Workday(this.start) {
    if (clockify != null) {
      fetchClockify();
      Timer.periodic(Duration(minutes: 1), (Timer t) => fetchClockify());
    }
  }

  Duration get totalWorkdayDuration {
    if (end == null) {
      return DateTime.now().difference(start);
    }
    return end.difference(start);
  }

  Duration get totalBreaksDuration {
    var duration = Duration();
    if (breaks.length == 0) {
      return duration;
    }
    breaks.forEach((Break brk) => duration += brk.duration);
    return duration;
  }

  Duration get workedTime => totalWorkdayDuration - totalBreaksDuration;
  Duration get unproductiveTime =>
      trackedTime == null ? workedTime : workedTime - trackedTime;
  bool get isPausedOrEnded => end == null ? false : true;

  void fetchClockify() async {
    trackedTime = await clockify.getTodaysHours();
  }
}

class Break {
  DateTime start, end;

  Break(this.start, this.end);

  Duration get duration => end.difference(start);
}
