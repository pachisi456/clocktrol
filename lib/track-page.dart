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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_start == null) {
      return _buildPristine();
    } else {
      return _buildStarted();
    }
  }

  Widget _buildPristine() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          'You haven\'t started your worday yet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
          ),
        ),
      ),
      RaisedButton(
        onPressed: () {
          setState(() {
            _start = DateTime.now();
          });
        },
        child: Text(
          'Start workday now',
          style: TextStyle(fontSize: 26),
        ),
      ),
    ]);
  }

  Widget _buildStarted() {
    return Text(
        'Workday started at ${_start.hour.toString()}:${_start.minute.toString()}');
  }
}
