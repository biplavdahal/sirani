import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysirani/data_model/forum.data.dart';
import 'package:mysirani/data_model/user.data.dart';

part 'forum_thread.data.freezed.dart';
part 'forum_thread.data.g.dart';

@freezed
class ForumThreadData with _$ForumThreadData {
  const factory ForumThreadData({
    @JsonKey(name: "totalcomments") required String totalComments,
    @JsonKey(name: "postby") required UserData postBy,
    @JsonKey(name: "usercomment") required String hasCommented,
    @JsonKey(name: "userlike") required String hasLiked,
    @JsonKey(name: "totallikes") required String totalLikes,
    @JsonKey(name: "forums") required ForumData data,
  }) = _ForumThreadData;

  factory ForumThreadData.fromJson(Map<String, dynamic> json) =>
      _$ForumThreadDataFromJson(json);
}
