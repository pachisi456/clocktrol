import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Clockify {
  final host = 'api.clockify.me';
  final basePath = '/api/v1';
  Object headers;

  Clockify(String apiKey) {
    headers = {'X-Api-Key': apiKey};
  }

  Future<Duration> getTodaysHours() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    String todayStr = DateFormat('yyyy-MM-dd').format(today) + 'T00:00:00Z';
    http.Response user = await getUser();
    var userBody = jsonDecode(user.body);
    http.Response times = await getTimeEntries(
        userBody['defaultWorkspace'].toString(),
        userBody['id'].toString(),
        todayStr);
    var timesBody = jsonDecode(times.body);
    Duration total = Duration();
    for (int i = 0; i < timesBody.length; i++) {
      total += parseDuration(timesBody[i]['timeInterval']['duration']);
    }
    return total;
  }

  // GET /user
  Future<http.Response> getUser() {
    var uri = Uri.https(host, basePath + '/user');
    return http.get(uri, headers: headers);
  }

  // GET /workspaces/{workspaceId}/user/{userId}/time-entries
  Future<http.Response> getTimeEntries(String workspaceId, userId, start) {
    var queryParameters = {
      'start': start.toString(),
    };
    Uri uri = Uri.https(
        host,
        basePath +
            '/workspaces/' +
            workspaceId +
            '/user/' +
            userId +
            '/time-entries',
        queryParameters);
    return http.get(uri, headers: headers);
  }

  // HELPERS.
  // Parse duration string received from API (Example: PT1H30M15S - 1 hour 30 minutes 15 seconds).
  Duration parseDuration(String duration) {
    RegExp exp = RegExp(r"PT(?:([0-9]*?)H)?(?:([0-9]*?)M)?(?:([0-9]*?)S)?");
    RegExpMatch match = exp.allMatches(duration).elementAt(0);
    int hours = match.group(1) != null ? int.parse(match.group(1)) : 0;
    int minutes = match.group(2) != null ? int.parse(match.group(2)) : 0;
    int seconds = match.group(3) != null ? int.parse(match.group(3)) : 0;
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}
