import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysirani/data_model/appointment_info.data.dart';
import 'package:mysirani/data_model/user.data.dart';

part 'appointment.data.freezed.dart';
part 'appointment.data.g.dart';

@freezed
class AppointmentData with _$AppointmentData {
  const factory AppointmentData({
    @JsonKey(name: "counselor") required UserData secondParty,
    int? rate,
    @JsonKey(name: "appointment") required AppointmentInfoData info,
  }) = _AppointmentData;

  factory AppointmentData.fromJson(Map<String, dynamic> json) =>
      _$AppointmentDataFromJson(json);
}
