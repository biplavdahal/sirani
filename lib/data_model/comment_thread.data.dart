import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysirani/data_model/comment.data.dart';
import 'package:mysirani/data_model/user.data.dart';

part 'comment_thread.data.freezed.dart';
part 'comment_thread.data.g.dart';

@freezed
class CommentThreadData with _$CommentThreadData {
  const factory CommentThreadData({
    @JsonKey(name: "commentby") required UserData commentBy,
    required String likes,
    @JsonKey(name: "userliked") required String hasLiked,
    @JsonKey(name: "comments") required CommentData data,
  }) = _CommentThreadData;

  factory CommentThreadData.fromJson(Map<String, dynamic> json) =>
      _$CommentThreadDataFromJson(json);
}
