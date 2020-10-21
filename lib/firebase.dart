import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:clocktrol/workday.dart';

class ClocktrolStore {
  final collection = 'workdays';

  // Write a newly created Workday starting now to Firebase and return it.
  Workday startNewDay() {
    Workday today = Workday(DateTime.now());
    Firestore.instance
        .collection(collection)
        .document(DateFormat('yyyy-MM-dd').format(today.start))
        .setData({'start': today.start});
    return today;
  }

  void updateToday(Workday today) {
    Firestore.instance
        .collection(collection)
        .document(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .updateData({
      'end': today.end,
      'breaks': today.breaks
          .map((brk) => {'start': brk.start, 'end': brk.end})
          .toList(),
      'trackedTime': today.trackedTime.inSeconds
    });
  }

  // Get all documents and return them as list of Workdays.
  Future<List<Workday>> getAll() async {
    QuerySnapshot all =
        await Firestore.instance.collection(collection).getDocuments();
    List<Workday> workdays =
        all.documents.map((document) => parseWorkday(document)).toList();
    return workdays;
  }

  // Parse data received from Firestore and return as Workday.
  @visibleForTesting
  Workday parseWorkday(DocumentSnapshot entry) {
    if (!entry.exists) {
      return null;
    }
    Workday workday = Workday(DateTime.fromMillisecondsSinceEpoch(
        entry.data['start'].seconds * 1000));
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
}
