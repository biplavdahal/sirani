import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.data.freezed.dart';
part 'user.data.g.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required int id,
    required String username,
    required String email,
    required String role,
    String? mobile,
    String? address,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'image') String? avatarUrl,
    String? type,
    @JsonKey(name: "chat_display") int? chatDisplay,
    @JsonKey(name: "video_display") int? videoDisplay,
    String? language,
    String? summary,
    String? skills,
    String? experience,
    String? education,
    @JsonKey(name: 'google_id') String? googleId,
    @JsonKey(name: 'facebook_id') String? facebookId,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
