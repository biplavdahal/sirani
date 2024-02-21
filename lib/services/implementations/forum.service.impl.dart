import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/comment.data.dart';
import 'package:mysirani/data_model/comment_thread.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/forum.data.dart';
import 'package:mysirani/data_model/forum_thread.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/forum.service.dart';

class ForumServiceImplementation extends ForumService {
  // Services
  final ApiService _apiService = locator<ApiService>();

  // Data

  final List<ForumThreadData> _selfPosts = [];
  @override
  List<ForumThreadData> get selfPosts => _selfPosts;

  bool _canLoadMore = true;
  @override
  bool get canLoadMore => _canLoadMore;

  List<ForumThreadData>? _threads;
  @override
  List<ForumThreadData>? get threads => _threads;

  late int _currentPage = 0;
  final int _threadsPerPage = 6;
  final int _commentThreadsPerPage = 5;

  @override
  void reset() {
    _canLoadMore = true;
    _currentPage = 0;
    _threads = null;
  }

  @override
  Future<void> fetchThreads(int? postBy) async {
    try {
      // Get self posts
      if (postBy != null) {
        final response = await _apiService.get(auForumThreads, params: {
          "access_token": locator<AuthenticationService>().auth!.accessToken,
          "post_by": postBy,
        });

        final data = constructResponse(response.data);

        if (data!["status"] == "failure") {
          throw ErrorData.fromJson(data);
        }

        _selfPosts.clear();

        final _threadsJson = data["data"]["forums"] as List;

        for (final threadJson in _threadsJson) {
          _selfPosts.add(ForumThreadData.fromJson(threadJson));
        }
        return;
      }

      // Get public posts
      if (canLoadMore) {
        _currentPage++;
        final response = await _apiService.get(auForumThreads, params: {
          "access_token": locator<AuthenticationService>().auth!.accessToken,
          "page": _currentPage,
          "limit": _threadsPerPage,
        });

        final data = constructResponse(response.data);

        if (data!["status"] == "failure") {
          throw ErrorData.fromJson(data);
        }

        final _threadsJson = data["data"]["forums"] as List;

        _threads ??= [];

        for (final threadJson in _threadsJson) {
          _threads!.add(ForumThreadData.fromJson(threadJson));
        }

        final int totalThreads = data["count"] as int;
        if (totalThreads > _currentPage * _threadsPerPage) {
          _canLoadMore = true;
        } else {
          _canLoadMore = false;
        }
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<bool> toggleThreadLike(int threadId) async {
    try {
      final _response = await _apiService.post(auForumLikeToggle, {
        "access_token": locator<AuthenticationService>().auth!.accessToken,
        "forum_id": threadId,
      });

      debugPrint(_response.data.toString());

      int index = _threads!.indexWhere((thread) => thread.data.id == threadId);
      _threads![index] = _threads![index].copyWith(
        hasLiked: _threads![index].hasLiked == "1" ? "0" : "1",
        totalLikes: _threads![index].hasLiked == "1"
            ? (int.parse(_threads![index].totalLikes) - 1).toString()
            : (int.parse(_threads![index].totalLikes) + 1).toString(),
      );

      int selfThreadIndex =
          _selfPosts.indexWhere((thread) => thread.data.id == threadId);
      if (!selfThreadIndex.isNegative) {
        _selfPosts[selfThreadIndex] = _selfPosts[selfThreadIndex].copyWith(
          hasLiked: _selfPosts[selfThreadIndex].hasLiked == "1" ? "0" : "1",
          totalLikes: _selfPosts[selfThreadIndex].hasLiked == "1"
              ? (int.parse(_selfPosts[selfThreadIndex].totalLikes) - 1)
                  .toString()
              : (int.parse(_selfPosts[selfThreadIndex].totalLikes) + 1)
                  .toString(),
        );
      }

      return true;
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchComments(int forumId,
      {required int page, required bool canLoad}) async {
    try {
      if (canLoad) {
        final currentCommentPage = page + 1;
        final response = await _apiService.get(auForumCommentThreads, params: {
          "access_token": locator<AuthenticationService>().auth!.accessToken,
          "forum_id": forumId,
          "page": currentCommentPage,
          "limit": _commentThreadsPerPage,
        });

        final data = constructResponse(response.data);

        if (data!["status"] == "failure") {
          throw ErrorData.fromJson(data);
        }

        final _commentThreadsJson = data["data"]["comments"] as List;

        final _commentThreads = <CommentThreadData>[];

        for (final commentThreadJson in _commentThreadsJson) {
          _commentThreads.add(CommentThreadData.fromJson(commentThreadJson));
        }

        final bool canLoadMore =
            data["count"] as int > currentCommentPage * _commentThreadsPerPage;

        return {
          "comments": _commentThreads,
          "canLoadMore": canLoadMore,
          "nextPage": currentCommentPage,
        };
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<CommentThreadData> addComment(
      {required int forumId, required String comment}) async {
    try {
      final response = await _apiService.post(auForumCommentAdd, {
        "access_token": locator<AuthenticationService>().auth!.accessToken,
        "forum_id": forumId,
        "comments": comment,
      });

      final data = constructResponse(response.data);

      if (!data!["status"]) {
        throw ErrorData.fromJson(data);
      }

      final index = _threads!.indexWhere((thread) => thread.data.id == forumId);
      _threads![index] = _threads![index].copyWith(
        totalComments:
            (int.parse(_threads![index].totalComments) + 1).toString(),
      );

      final selfThreadIndex =
          _selfPosts.indexWhere((thread) => thread.data.id == forumId);
      if (!selfThreadIndex.isNegative) {
        _selfPosts[selfThreadIndex] = _selfPosts[selfThreadIndex].copyWith(
          totalComments:
              (int.parse(_selfPosts[selfThreadIndex].totalComments) + 1)
                  .toString(),
        );
      }

      return CommentThreadData(
        hasLiked: "0",
        likes: "0",
        data: CommentData.fromJson(
          data["data"],
        ),
        commentBy: locator<AuthenticationService>().auth!.user,
      );
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<bool> removeComment(int commentId, {required int forumId}) async {
    try {
      final response = await _apiService.post(
        auForumCommentRemove,
        {
          "access_token": locator<AuthenticationService>().auth!.accessToken,
          "id": commentId,
        },
      );

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final index = _threads!.indexWhere((thread) => thread.data.id == forumId);
      _threads![index] = _threads![index].copyWith(
        totalComments:
            (int.parse(_threads![index].totalComments) - 1).toString(),
      );

      final selfPostIndex =
          _selfPosts.indexWhere((thread) => thread.data.id == forumId);
      if (!selfPostIndex.isNegative) {
        _selfPosts[selfPostIndex] = _selfPosts[selfPostIndex].copyWith(
          totalComments:
              (int.parse(_selfPosts[selfPostIndex].totalComments) - 1)
                  .toString(),
        );
      }

      return true;
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<bool> toggleCommentLike(int commentId) async {
    try {
      final response = await _apiService.post(auForumCommentLikeToggle, {
        "access_token": locator<AuthenticationService>().auth!.accessToken,
        "forum_comment_id": commentId,
        "review_by": locator<AuthenticationService>().auth!.userId,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      return data["data"]["status"] == 1;
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> removeThread(int threadId) async {
    try {
      final response = await _apiService.post(auForumThreadDelete, {
        "access_token": locator<AuthenticationService>().auth!.accessToken,
        "forum_id": threadId,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final index =
          _threads!.indexWhere((thread) => thread.data.id == threadId);
      _threads!.removeAt(index);

      final selfPostIndex =
          _selfPosts.indexWhere((thread) => thread.data.id == threadId);

      if (!selfPostIndex.isNegative) {
        _selfPosts.removeAt(selfPostIndex);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> addThread(String description, bool anonymous) async {
    try {
      final response = await _apiService.post(auForumThreadAdd, {
        "access_token": locator<AuthenticationService>().auth!.accessToken,
        "description": description,
        "anonymous": anonymous ? 1 : 0,
        "title": "",
        "status": "Active",
        "forum_category_id": 0,
        "tags": "",
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final thread = ForumData.fromJson(data["data"]);

      _threads!.insert(
        0,
        ForumThreadData(
          totalComments: "0",
          postBy: locator<AuthenticationService>().auth!.user,
          hasCommented: "No",
          hasLiked: "0",
          totalLikes: "0",
          data: thread,
        ),
      );
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> editThread(
      String description, bool anonymous, int forumId) async {
    try {
      final response = await _apiService.post(auForumThreadEdit, {
        "access_token": locator<AuthenticationService>().auth!.accessToken,
        "description": description,
        "anonymous": anonymous ? 1 : 0,
        "title": "",
        "status": "Active",
        "forum_category_id": 0,
        "tags": "",
        "forum_id": forumId,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final index = _threads!.indexWhere((thread) => thread.data.id == forumId);

      _threads![index] = _threads![index].copyWith(
        data: ForumData.fromJson(data["data"]),
      );
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> reportThread(int threadId, {required String detail}) async {
    try {
      final response = await _apiService.post(auForumThreadReport, {
        "access_token": locator<AuthenticationService>().auth!.accessToken,
        "forum_id": threadId,
        "details": detail,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> postAnIssueThread(int threadId, {required String detail}) async {
    try {
      final response = await _apiService.post(auForumThreadIssue, {
        "access_token": locator<AuthenticationService>().auth!.accessToken,
        "forum_id": threadId,
        "details": detail,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }
}
