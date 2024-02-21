import 'package:freezed_annotation/freezed_annotation.dart';

part 'counsellor_schedule.data.freezed.dart';
part 'counsellor_schedule.data.g.dart';

@freezed
class CounsellorScheduleData with _$CounsellorScheduleData {
  const factory CounsellorScheduleData({
    @JsonKey(name: "counselor_schedule_id") required int id,
    @JsonKey(name: "days") required String day,
    @JsonKey(name: "time") required String fromTime,
    @JsonKey(name: "to_time") required String toTime,
    @JsonKey(name: "status") required String status,
  }) = _CounsellorScheduleData;

  factory CounsellorScheduleData.fromJson(Map<String, dynamic> json) =>
      _$CounsellorScheduleDataFromJson(json);
}
