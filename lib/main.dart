import 'package:flutter/material.dart';
import 'package:clocktrol/track-page.dart';

void main() => runApp(MyApp());

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
      home: TrackPage(),
    );
  }
}
