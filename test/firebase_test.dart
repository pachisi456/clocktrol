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
    final ds = DocumentSnapshotMock('', {
      'start': Timestamp.fromMicrosecondsSinceEpoch(1588418587140000),
    });

    Workday workday = parseWorkday(ds);
    expect(workday.start, DateTime(2020, 5, 2, 13, 23, 7));
  });

  test('Ended workday with breaks and tracked time should be parsed correctly',
      () {
    final ds = DocumentSnapshotMock('', {
      'start': Timestamp.fromMillisecondsSinceEpoch(1588489200000),
      'trackedTime': Duration(hours: 1, minutes: 30).inSeconds,
      'breaks': [
        {
          'start': Timestamp.fromMillisecondsSinceEpoch(1588492800000),
          'end': Timestamp.fromMillisecondsSinceEpoch(1588496400000)
        },
        {
          'start': Timestamp.fromMillisecondsSinceEpoch(1588500000000),
          'end': Timestamp.fromMillisecondsSinceEpoch(1588503600000)
        }
      ],
      'end': Timestamp.fromMillisecondsSinceEpoch(1588518000000)
    });

    Workday workday = parseWorkday(ds);
    expect(workday.start, DateTime(2020, 5, 3, 9));
    expect(workday.trackedTime.inMinutes, 90);
    expect(workday.breaks[0].start, DateTime(2020, 5, 3, 10));
    expect(workday.breaks[0].end, DateTime(2020, 5, 3, 11));
    expect(workday.breaks[1].start, DateTime(2020, 5, 3, 12));
    expect(workday.breaks[1].end, DateTime(2020, 5, 3, 13));
    expect(workday.end, DateTime(2020, 5, 3, 17));
    expect(workday.totalWorkdayDuration, Duration(hours: 8));
    expect(workday.totalBreaksDuration, Duration(hours: 2));
    expect(workday.workedTime, Duration(hours: 6));
    expect(workday.isPausedOrEnded, true);
    expect(workday.unproductiveTime, Duration(hours: 4, minutes: 30));
  });
}
