import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_info.data.freezed.dart';
part 'appointment_info.data.g.dart';

@freezed
class AppointmentInfoData with _$AppointmentInfoData {
  const factory AppointmentInfoData({
    @JsonKey(name: 'appointment_id') required int appointmentId,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'counselor_id') required int counselorId,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'date') required String date,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'detail') required String detail,
    @JsonKey(name: 'chat_plan_order_id') int? chatPlanOrderId,
    @JsonKey(name: 'time') required String time,
  }) = _AppointmentInfoData;

  factory AppointmentInfoData.fromJson(Map<String, dynamic> json) =>
      _$AppointmentInfoDataFromJson(json);
}
