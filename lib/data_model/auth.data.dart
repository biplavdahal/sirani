import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysirani/data_model/user.data.dart';

part 'auth.data.freezed.dart';
part 'auth.data.g.dart';

@freezed
class AuthData with _$AuthData {
  const factory AuthData({
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "user_id") required int userId,
    required int balance,
    required String username,
    @JsonKey(name: "data") required UserData user,
  }) = _AuthData;

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);
}
