import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:clocktrol/track-page.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: Clocktrol(),
    );
  }
}

class Clocktrol extends StatefulWidget {
  Clocktrol({Key key}) : super(key: key);

  @override
  _ClocktrolState createState() => _ClocktrolState();
}

class _ClocktrolState extends State<Clocktrol> {
  int _selectedIndex = 1;

  void _onTabSwitch(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clocktrol'),
      ),
      body: Center(
        child: <Widget>[
          Text('Hello World!'),
          TrackPage(),
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
}
