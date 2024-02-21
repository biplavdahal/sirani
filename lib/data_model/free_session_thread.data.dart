import 'package:freezed_annotation/freezed_annotation.dart';

part 'free_session_thread.data.freezed.dart';
part 'free_session_thread.data.g.dart';

@freezed
class FreeSessionThreadData with _$FreeSessionThreadData {
  const factory FreeSessionThreadData({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "image") required String image,
    @JsonKey(name: "username") required String username,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "full_name") required String fullName,
    @JsonKey(name: "online") required String status,
  }) = _FreeSessionThreadData;

  factory FreeSessionThreadData.fromJson(Map<String, dynamic> json) =>
      _$FreeSessionThreadDataFromJson(json);
}
