import 'package:clocktrol/firebase.dart';
import 'package:clocktrol/history_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clocktrol/main.dart';
import 'package:clocktrol/workday.dart';

class ClocktrolStoreMock extends Mock implements ClocktrolStore {}

void main() {
  final workday1 = Workday(DateTime(2020, 7, 27, 7));
  workday1.end = DateTime(2020, 7, 27, 16);
  final workday2 = Workday(DateTime(2020, 7, 28, 7));
  workday2.end = DateTime(2020, 7, 28, 14);
  final workday3 = Workday(DateTime(2020, 7, 29, 5));
  workday3.end = DateTime(2020, 7, 29, 19);
  final today = Workday(DateTime.now());

  testWidgets('Testing Main Widget', (WidgetTester tester) async {
    final storeMock = ClocktrolStoreMock();
    when(storeMock.getAll()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildTestableWidget(Clocktrol(storeMock)));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(HistoryPage), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('Testing Main State with empty history',
      (WidgetTester tester) async {
    final storeMock = ClocktrolStoreMock();
    when(storeMock.getAll()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildTestableWidget(Clocktrol(storeMock)));

    final ClocktrolState state = tester.state(find.byType(Clocktrol));
    expect(state.history, null);
    expect(state.today, null);
  });

  testWidgets('Testing Main State with today and empty history',
      (WidgetTester tester) async {
    final storeMock = ClocktrolStoreMock();
    when(storeMock.getAll()).thenAnswer((_) async => [today]);

    await tester.pumpWidget(buildTestableWidget(Clocktrol(storeMock)));

    final ClocktrolState state = tester.state(find.byType(Clocktrol));
    expect(state.history, []);
    expect(state.today, today);
  });

  testWidgets('Testing Main State with today and history',
      (WidgetTester tester) async {
    final storeMock = ClocktrolStoreMock();
    when(storeMock.getAll()).thenAnswer((_) async => [workday1, today]);

    await tester.pumpWidget(buildTestableWidget(Clocktrol(storeMock)));

    final ClocktrolState state = tester.state(find.byType(Clocktrol));
    expect(state.history.length, 1);
    expect(state.today, today);
  });

  testWidgets('Testing Main State with one history item',
      (WidgetTester tester) async {
    final storeMock = ClocktrolStoreMock();

    when(storeMock.getAll()).thenAnswer((_) async => [workday1]);

    await tester.pumpWidget(buildTestableWidget(Clocktrol(storeMock)));

    final ClocktrolState state = tester.state(find.byType(Clocktrol));
    expect(state.history.length, 1);
    expect(state.today, null);
  });

  testWidgets('Testing Main State with many history items',
      (WidgetTester tester) async {
    final storeMock = ClocktrolStoreMock();
    when(storeMock.getAll())
        .thenAnswer((_) async => [workday1, workday2, workday3, today]);

    await tester.pumpWidget(buildTestableWidget(Clocktrol(storeMock)));

    final ClocktrolState state = tester.state(find.byType(Clocktrol));
    expect(state.history.length, 3);
    expect(state.today, today);
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
