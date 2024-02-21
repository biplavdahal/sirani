import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.data.freezed.dart';
part 'comment.data.g.dart';

@freezed
class CommentData with _$CommentData {
  const factory CommentData({
    @JsonKey(name: "forum_comment_id") required int id,
    @JsonKey(name: "comments") required String body,
    @JsonKey(name: "datetime") required String dateTime,
  }) = _CommentData;

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);
}
