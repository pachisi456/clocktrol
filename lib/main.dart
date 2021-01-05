import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:clocktrol/firebase.dart';
import 'package:clocktrol/history_page.dart';
import 'package:clocktrol/track_page.dart';
import 'package:clocktrol/workday.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ClocktrolStore _store = ClocktrolStore();
  final MaterialColor _primaryColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: _primaryColor,
        buttonTheme: ButtonThemeData(
          minWidth: 300,
          height: 45,
          buttonColor: _primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Clocktrol(_store),
    );
  }
}

class Clocktrol extends StatefulWidget {
  Clocktrol(this._store, {Key key}) : super(key: key);

  final ClocktrolStore _store;

  @override
  ClocktrolState createState() => ClocktrolState();
}

class ClocktrolState extends State<Clocktrol> {
  int _selectedIndex = 0;
  @visibleForTesting
  List<Workday> history;
  @visibleForTesting
  Workday today;
  @visibleForTesting
  bool percentageMode = false;

  @override
  void initState() {
    // Load persistent data from disk.
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('percentageMode') ?? false != percentageMode) {
        setState(() => percentageMode = true);
      }
    });

    // Load clockify data.
    widget._store.getAll().then((all) {
      if (all.length > 0) {
        DateTime now = DateTime.now();
        setState(() {
          if (all[all.length - 1]
              .start
              .isAfter(DateTime(now.year, now.month, now.day))) {
            today = all.removeLast();
            today.fetchPeriodically();
          }
          history = all.reversed.toList();
        });
      }
    });
    super.initState();
  }

  void _onTabSwitch(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _switchColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clocktrol'),
        actions: <Widget>[
          Icon(Icons.schedule),
          Switch(
            value: percentageMode,
            onChanged: _togglePercentageMode,
            inactiveThumbColor: _switchColor,
            activeColor: _switchColor,
          ),
          Container(
            margin: const EdgeInsets.only(right: 17),
            child: Center(
              child: Text(
                '%',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: <Widget>[
          HistoryPage(percentageMode, history),
          TrackPage(
            percentageMode,
            today,
            () => _setUpWorkday(),
            () => _stopOrContinueWorkday(),
          ),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.reorder),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            title: Text('Today'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTabSwitch,
      ),
    );
  }

  void _togglePercentageMode(toggled) async {
    setState(() {
      percentageMode = toggled;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('percentageMode', toggled);
  }

  void _setUpWorkday([Workday wd]) {
    setState(() {
      today = widget._store.startNewDay();
    });
    Timer.periodic(Duration(seconds: 2), (Timer t) => _updateData());
  }

  void _stopOrContinueWorkday() {
    if (!today.isPausedOrEnded) {
      // Assume workday is ended.
      today.end = DateTime.now();
    } else {
      // Add break, from end to now and reset end.
      today.breaks.add(Break(today.end, DateTime.now()));
      today.end = null;
    }
    _updateData();
  }

  void _updateData() {
    widget._store.updateToday(today);
    setState(() {});
  }
}
