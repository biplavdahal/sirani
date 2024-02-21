import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum.data.freezed.dart';
part 'forum.data.g.dart';

@freezed
class ForumData with _$ForumData {
  const factory ForumData({
    @JsonKey(name: 'forum_id') required int id,
    required String description,
    @JsonKey(name: "datetime") required String dateTime,
    @JsonKey(name: "anonymous") int? isAnonymous,
  }) = _ForumData;

  factory ForumData.fromJson(Map<String, dynamic> json) =>
      _$ForumDataFromJson(json);
}
