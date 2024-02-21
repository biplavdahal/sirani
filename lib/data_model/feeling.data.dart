import 'package:freezed_annotation/freezed_annotation.dart';

part 'feeling.data.freezed.dart';
part 'feeling.data.g.dart';

@freezed
class FeelingData with _$FeelingData {
  const factory FeelingData({
    @JsonKey(name: "data") required String type,
    @JsonKey(name: "response") required String message,
  }) = _FeelingData;

  factory FeelingData.fromJson(Map<String, dynamic> json) =>
      _$FeelingDataFromJson(json);
}
