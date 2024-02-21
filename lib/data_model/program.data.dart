import 'package:freezed_annotation/freezed_annotation.dart';

part 'program.data.freezed.dart';
part 'program.data.g.dart';

@freezed
class ProgramData with _$ProgramData {
  const factory ProgramData({
    @JsonKey(name: "program_id") required int id,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "slug") required String slug,
    @JsonKey(name: "image") required String image,
    @JsonKey(name: "duration") required String duration,
    @JsonKey(name: "short_detail") required String shortDetail,
    @JsonKey(name: "full_detail") required String fullDetail,
  }) = _ProgramData;

  factory ProgramData.fromJson(Map<String, dynamic> json) =>
      _$ProgramDataFromJson(json);
}
