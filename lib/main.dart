import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClockPage(),
    );
  }
}

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  DateTime _start;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clocktrol'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildChild(),
          ],
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (_start == null) {
      return RaisedButton(
        onPressed: () {
          setState(() {
            _start = DateTime.now();
          });
        },
        child: Text('Start workday'),
      );
    }
    return Text(
        'Workday started at ${_start.hour.toString()}:${_start.minute.toString()}');
  }
}
