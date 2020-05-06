import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clocktrol/firebase.dart';
import 'package:clocktrol/workday.dart';

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  final String documentID;
  final Map<String, dynamic> data;

  DocumentSnapshotMock([this.documentID, this.data]);

  bool get exists => data != null;
}

void main() {
  test('parseWorkday() should return null on empty DocumentSnapshot', () {
    final ds = DocumentSnapshotMock();
    expect(parseWorkday(ds), null);
  });

  test('Started workday should be parsed correctly', () {
    const start = 1588518000;
    final ds = DocumentSnapshotMock('', {
      'start': Timestamp.fromMillisecondsSinceEpoch(start),
    });

    Workday workday = parseWorkday(ds);
    expect(workday.start.millisecondsSinceEpoch, start);
  });

  test('Ended workday with breaks and tracked time should be parsed correctly',
      () {
    const start = 1588489200000;
    const breakOneStart = 1588492800000;
    const breakOneEnd = 1588496400000;
    const breakTwoStart = 1588500000000;
    const breakTwoEnd = 1588503600000;
    const end = 1588518000000;

    final ds = DocumentSnapshotMock('', {
      'start': Timestamp.fromMillisecondsSinceEpoch(start),
      'trackedTime': Duration(hours: 1, minutes: 30).inSeconds,
      'breaks': [
        {
          'start': Timestamp.fromMillisecondsSinceEpoch(breakOneStart),
          'end': Timestamp.fromMillisecondsSinceEpoch(breakOneEnd)
        },
        {
          'start': Timestamp.fromMillisecondsSinceEpoch(breakTwoStart),
          'end': Timestamp.fromMillisecondsSinceEpoch(breakTwoEnd)
        }
      ],
      'end': Timestamp.fromMillisecondsSinceEpoch(end)
    });

    Workday workday = parseWorkday(ds);
    expect(workday.start.millisecondsSinceEpoch, start);
    expect(workday.trackedTime.inMinutes, 90);
    expect(workday.breaks[0].start.millisecondsSinceEpoch, breakOneStart);
    expect(workday.breaks[0].end.millisecondsSinceEpoch, breakOneEnd);
    expect(workday.breaks[1].start.millisecondsSinceEpoch, breakTwoStart);
    expect(workday.breaks[1].end.millisecondsSinceEpoch, breakTwoEnd);
    expect(workday.end.millisecondsSinceEpoch, end);
    expect(workday.totalWorkdayDuration, Duration(hours: 8));
    expect(workday.totalBreaksDuration, Duration(hours: 2));
    expect(workday.workedTime, Duration(hours: 6));
    expect(workday.isPausedOrEnded, true);
    expect(workday.unproductiveTime, Duration(hours: 4, minutes: 30));
  });
}
