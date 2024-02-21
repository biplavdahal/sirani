import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/data_model/counsellor_schedule.data.dart';

class UpdateScheduleArgument extends Arguments {
  final CounsellorScheduleData? schedule;

  UpdateScheduleArgument(this.schedule);
}
