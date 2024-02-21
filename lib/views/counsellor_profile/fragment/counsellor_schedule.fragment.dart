import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/data_model/counsellor_schedule.data.dart';
import 'package:mysirani/helpers/schedule_formatter.helper.dart';
import 'package:mysirani/theme.dart';

class CounsellorSchedule extends StatelessWidget {
  final List<CounsellorScheduleData> schedules;

  const CounsellorSchedule(this.schedules, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedSchedules = formatSchedule(schedules);

    return ListView.builder(
      itemBuilder: (context, index) {
        final day = formattedSchedules.keys.toList()[index];

        return ExpansionTile(
          leading: const Icon(MdiIcons.calendarClockOutline),
          subtitle: Text(
            "${formattedSchedules[day]!.length} sessions",
            style: const TextStyle(color: AppColor.secondaryTextColor),
          ),
          title: Text(day),
          children: formattedSchedules[day]!.map((schedule) {
            return ListTile(
              title: Text("${schedule.fromTime} - ${schedule.toTime}"),
              leading: const Icon(
                Icons.schedule,
                color: Colors.green,
              ),
            );
          }).toList(),
        );
      },
      itemCount: formattedSchedules.length,
    );
  }
}
