import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formattedDateTime(
  String unformattedDateTime, {
  bool showTime = true,
}) {
  DateTime dateTime = DateTime.parse(unformattedDateTime);
  DateFormat format = DateFormat.yMMMMd();

  if (showTime) {
    format = format.add_jm();
  }

  String formattedDate = format.format(dateTime);

  return formattedDate;
}

bool canStartSession(String startTime) {
  DateTime now = DateTime.now();
  DateTime start = DateTime.parse(startTime);
  DateTime end = start.add(const Duration(hours: 1));

  debugPrint(start.difference(now).inMinutes.toString());

  // Session can be started if now is between start and end time
  // or only before 10minutes from start time
  return (now.isAfter(start) && now.isBefore(end)) ||
      (start.difference(now).inMinutes < 10 &&
          !start.difference(now).isNegative);
}

Duration durationFromDouble(double time) {
  if (time < 1) {
    return Duration(seconds: (time * 60).toInt());
  }

  int minute = (time % time.ceil()).toInt();
  int second = ((time % minute) * 60).toInt();

  return Duration(minutes: minute, seconds: second);
}
