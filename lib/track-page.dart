import 'package:flutter/material.dart';

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
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
