double date2Percentage(
    {required DateTime startingDate, required DateTime endingDate}) {
  final now = DateTime.now().microsecondsSinceEpoch;
  final sd = startingDate.microsecondsSinceEpoch;
  final ed = endingDate.microsecondsSinceEpoch;

  final newStartSet = (0 / sd) + (now - sd);
  final newEndSet = ed - sd;

  return (newStartSet / newEndSet);
}

String weekday(int index) {
  List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  return weekdays[index - 1];
}

String convert12To24Format(String time) {
  final fromTime = time.split("-").first.trim();
  final timeType = fromTime.split(" ").last.toLowerCase();
  int t = int.parse(fromTime.split(":").first);

  if (timeType == "pm" && t < 12) {
    return "${12 + t}:00:00";
  } else {
    return "$t:00:00";
  }
}

String addDurationToTimeStr({
  required String time,
  required Duration toBeAdded,
}) {
  List<String> timeArr = time.split(":");

  int hour = int.parse(timeArr[0]);
  int minute = int.parse(timeArr[1]);

  Duration newDuration =
      Duration(hours: hour, minutes: minute, seconds: 0) + toBeAdded;

  return "${newDuration.inHours}:${newDuration.inMinutes % 60}:00";
}
