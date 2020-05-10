import 'package:flutter/widgets.dart';

import 'workday.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key key,
    this.history,
  }) : super(key: key);

  final List<Workday> history;

  @override
  Widget build(BuildContext context) {
    print(history);
    return Text('New widget.' + history.toString());
  }
}
