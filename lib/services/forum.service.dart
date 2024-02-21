import 'package:mysirani/data_model/comment_thread.data.dart';
import 'package:mysirani/data_model/forum_thread.data.dart';

abstract class ForumService {
  /// Get all available forum entries.
  List<ForumThreadData>? get threads;

  /// Get all self posts
  List<ForumThreadData> get selfPosts;

  /// Can load more threads.
  bool get canLoadMore;

  /// Fetch all available forum entries.
  Future<void> fetchThreads(int? postBy);

  /// Add new thread to the forum
  Future<void> addThread(String description, bool anonymous);

  /// Add new thread to the forum
  Future<void> editThread(String description, bool anonymous, int forumId);

  /// Fetch toggle thread like
  Future<bool> toggleThreadLike(int threadId);

  /// Delete forum thread
  Future<void> removeThread(int threadId);

  /// Fetch comments
  ///
  /// Returns a map that contains two key value pairs:
  /// - `comments`: List of comments
  /// - `canLoadMore`: [true] if Can load more comments
  /// - `nextPage`: Next page to load
  Future<Map<String, dynamic>?> fetchComments(
    int forumId, {
    required int page,
    required bool canLoad,
  });

  /// Add comment to the forum thread and returns added comment thread.
  Future<CommentThreadData> addComment({
    required int forumId,
    required String comment,
  });

  /// Remove comment from the forum thread and returns true if removed.
  Future<bool> removeComment(
    int commentId, {
    required int forumId,
  });

  /// Toggle comment like
  Future<bool> toggleCommentLike(int commentId);

  /// Reset all
  void reset();

  /// Report forum thread
  Future<void> reportThread(int threadId, {required String detail});

  /// Post an issue for thread
  Future<void> postAnIssueThread(int threadId, {required String detail});
}
