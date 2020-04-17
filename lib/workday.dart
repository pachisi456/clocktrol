class Workday {
  DateTime start, end;
  List<Break> breaks;
  Duration trackedTime;

  Workday(this.start);

  Duration get totalWorkdayDuration => end.difference(start);

  Duration get totalBreaksDuration {
    var duration = Duration();
    if (breaks.length == 0) {
      return duration;
    }
    breaks.map((Break brk) => duration += brk.duration);
    return duration;
  }
  
  Duration get workedTime => totalWorkdayDuration - totalBreaksDuration;
  Duration get unproductiveTime => workedTime - trackedTime;
}

class Break {
  DateTime start, end;

  Break(this.start);

  Duration get duration => end.difference(start);
}
