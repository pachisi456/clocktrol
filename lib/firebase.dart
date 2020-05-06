import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:clocktrol/workday.dart';

const COLLECTION = 'workdays';

// Get today's Workday from Firebase if existent, otherwise return null.
Future<Workday> getToday() async {
  DocumentSnapshot today = await Firestore.instance
      .collection(COLLECTION)
      .document(DateFormat('yyyy-MM-dd').format(DateTime.now()))
      .get();
  return parseWorkday(today);
}

// Write a newly created Workday starting now to Firebase and return it.
Workday startNewDay() {
  Workday today = Workday(DateTime.now());
  Firestore.instance
      .collection(COLLECTION)
      .document(DateFormat('yyyy-MM-dd').format(today.start))
      .setData({'start': today.start});
  return today;
}

void updateToday(Workday today) {
  Firestore.instance
      .collection(COLLECTION)
      .document(DateFormat('yyyy-MM-dd').format(DateTime.now()))
      .updateData({
    'end': today.end,
    'breaks': today.breaks
        .map((brk) => {'start': brk.start, 'end': brk.end})
        .toList(),
    'trackedTime': today.trackedTime.inSeconds
  });
}

/*
List<Workday> getAll() {
  // TODO
}
*/

// Parse data received from Firestore and return as Workday.
@visibleForTesting
Workday parseWorkday(DocumentSnapshot entry) {
  if (!entry.exists) {
    return null;
  }
  Workday workday = Workday(
      DateTime.fromMillisecondsSinceEpoch(entry.data['start'].seconds * 1000));
  if (entry.data['end'] != null) {
    workday.end =
        DateTime.fromMillisecondsSinceEpoch(entry.data['end'].seconds * 1000);
  }
  if (entry.data['breaks'] != null) {
    List breaks = entry.data['breaks'];
    for (int i = 0; i < breaks.length; i++) {
      workday.breaks.add(Break(
          DateTime.fromMillisecondsSinceEpoch(
              breaks[i]['start'].seconds * 1000),
          DateTime.fromMillisecondsSinceEpoch(
              breaks[i]['end'].seconds * 1000)));
    }
  }
  if (entry.data['trackedTime'] != null) {
    workday.trackedTime = Duration(seconds: entry.data['trackedTime']);
  }
  return workday;
}
