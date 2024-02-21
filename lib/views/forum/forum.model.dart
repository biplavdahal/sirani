import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysirani/data_model/comment_thread.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/forum_thread.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/forum.service.dart';
import 'package:mysirani/views/forum/forum.argument.dart';

class ForumModel extends ViewModel with SnackbarMixin {
  // Services
  final ForumService _forumService = locator<ForumService>();

  // UI Components
  final ScrollController _commentThreadsScrollController = ScrollController();
  ScrollController get commentThreadsScrollController =>
      _commentThreadsScrollController;
  final GlobalKey<FormState> _commentFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get commentFormKey => _commentFormKey;
  final TextEditingController _commentTextController = TextEditingController();
  TextEditingController get commentTextController => _commentTextController;

  // Data
  late ForumThreadData _thread;
  ForumThreadData get thread => _thread;

  late List<CommentThreadData> _comments;
  List<CommentThreadData> get comments => _comments;

  int _nextPage = 0;
  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  // Actions
  Future<void> init(ForumArgument argument) async {
    _thread = argument.thread;
    setIdle();
    try {
      setAlert(viewState: EState.error, message: "");
      setLoading();
      final response = await _forumService.fetchComments(
        _thread.data.id,
        page: _nextPage,
        canLoad: _canLoadMore,
      );
      if (response != null) {
        _comments = response["comments"];
        _nextPage = response["nextPage"];
        _canLoadMore = response["canLoadMore"];
      }
      setIdle();
      if (_commentThreadsScrollController.hasListeners == false) {
        _commentThreadsScrollController.addListener(() async {
          if (_commentThreadsScrollController.position.atEdge) {
            if (_commentThreadsScrollController.position.pixels != 0) {
              final response = await _forumService.fetchComments(
                _thread.data.id,
                page: _nextPage,
                canLoad: _canLoadMore,
              );
              if (response != null) {
                _comments.addAll([...response["comments"]]);
                _nextPage = response["nextPage"];
                _canLoadMore = response["canLoadMore"];
              }
              setIdle();
            }
          }
        });
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
      setAlert(viewState: EState.error, message: e.response);
    }
  }

  Future<void> setLike(int id) async {
    try {
      setWidgetBusy("$id-like-btn");
      await _forumService.toggleThreadLike(id);
      _thread = _thread.copyWith(
        hasLiked: _thread.hasLiked == "1" ? "0" : "1",
        totalLikes: _thread.hasLiked == "1"
            ? (int.parse(_thread.totalLikes) - 1).toString()
            : (int.parse(_thread.totalLikes) + 1).toString(),
      );
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
    unsetWidgetBusy("$id-like-btn");
  }

  Future<void> onAddCommentPressed() async {
    try {
      if (_commentFormKey.currentState!.validate()) {
        setWidgetBusy('comment-btn');
        final newComment = await _forumService.addComment(
          forumId: _thread.data.id,
          comment: _commentTextController.text.trim(),
        );

        _comments.insert(0, newComment);
        _thread = _thread.copyWith(
          totalComments: (int.parse(_thread.totalComments) + 1).toString(),
        );
        _commentTextController.clear();
        setIdle();
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Comment posted!",
            type: ESnackbarType.success,
          ),
        );
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
    unsetWidgetBusy('comment-btn');
  }

  Future<bool> onDeleteComment(int commentId) async {
    try {
      final action = await _forumService.removeComment(commentId,
          forumId: _thread.data.id);

      if (action) {
        _comments.removeWhere((comment) => comment.data.id == commentId);
        _thread = _thread.copyWith(
          totalComments: (int.parse(_thread.totalComments) - 1).toString(),
        );
      }
      setIdle();

      unsetWidgetBusy("deleting-$commentId");
      return action;
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
      return false;
    }
  }

  Future<void> toggleCommentLike(int commentId) async {
    try {
      setWidgetBusy("$commentId-like-btn");

      await _forumService.toggleCommentLike(commentId);

      final commentIndex =
          _comments.indexWhere((comment) => comment.data.id == commentId);

      _comments[commentIndex] = _comments[commentIndex].copyWith(
        hasLiked: _comments[commentIndex].hasLiked == "Yes" ? "No" : "Yes",
        likes: _comments[commentIndex].hasLiked == "Yes"
            ? (int.parse(_comments[commentIndex].likes) - 1).toString()
            : (int.parse(_comments[commentIndex].likes) + 1).toString(),
      );

      setIdle();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
    unsetWidgetBusy("$commentId-like-btn");
  }
}
