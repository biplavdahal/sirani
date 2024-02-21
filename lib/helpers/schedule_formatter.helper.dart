import 'package:mysirani/data_model/counsellor_schedule.data.dart';

Map<String, List<CounsellorScheduleData>> formatSchedule(
    List<CounsellorScheduleData> schedule) {
  Map<String, List<CounsellorScheduleData>> scheduleMap = {};

  Set days = schedule.map((datum) => datum.day).toSet();

  for (final day in days) {
    scheduleMap[day] = schedule.where((datum) => datum.day == day).toList();
  }

  return scheduleMap;
}
