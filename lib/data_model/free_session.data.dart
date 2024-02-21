import 'package:freezed_annotation/freezed_annotation.dart';

part 'free_session.data.freezed.dart';
part 'free_session.data.g.dart';

@freezed
class FreeSessionData with _$FreeSessionData {
  const factory FreeSessionData({
    @JsonKey(name: "free_volunteer_session") required int volunteerSession,
    @JsonKey(name: "free_boddies_session") required int buddiesSession,
    @JsonKey(name: "remaining_free_volunteer_session")
        required int remainingVolunteerSession,
    @JsonKey(name: "remaining_free_boddies_session")
        required int remainingBuddiesSession,
  }) = _FreeSessionData;

  factory FreeSessionData.fromJson(Map<String, dynamic> json) =>
      _$FreeSessionDataFromJson(json);
}
