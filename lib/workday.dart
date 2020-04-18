class Workday {
  DateTime start, end;
  List<Break> breaks = [];
  Duration trackedTime = Duration();

  Workday(this.start);

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
}

class Break {
  DateTime start, end;

  Break(this.start, this.end);

  Duration get duration => end.difference(start);
}
