import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/resource.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/resource.service.dart';

class ResourceServiceImplementation implements ResourceService {
  final ApiService _apiService = locator<ApiService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final int _maxResourcePerPage = 7;

  int _currentBlogsPage = 0;
  int _currentVideosPage = 0;

  final List<ResourceData> _blogs = [];
  @override
  List<ResourceData> get blogs => _blogs;

  bool _hasMoreBlogs = true;
  @override
  bool get hasMoreBlogs => _hasMoreBlogs;

  bool _hasMoreVideos = true;
  @override
  bool get hasMoreVideos => _hasMoreVideos;

  final List<ResourceData> _videos = [];
  @override
  List<ResourceData> get videos => _videos;

  @override
  void reset(String type) {
    if (type == "blog") {
      _currentBlogsPage = 0;
      _hasMoreBlogs = true;
      _blogs.clear();
    }

    if (type == "video") {
      _currentVideosPage = 0;
      _hasMoreVideos = true;
      _videos.clear();
    }
  }

  @override
  Future<void> fetchBlogs() async {
    try {
      if (_hasMoreBlogs) {
        _currentBlogsPage++;

        final response = await _apiService.get(auGetBlogs, params: {
          'page': _currentBlogsPage,
          'limit': _maxResourcePerPage,
          'access_token': _authenticationService.auth!.accessToken,
        });

        final data = constructResponse(response.data);

        if (data!["status"] == "failure") {
          throw ErrorData.fromJson(data);
        }

        final _blogsJson = data["data"] as List;

        for (final blogJson in _blogsJson) {
          _blogs.add(ResourceData.fromJson(blogJson));
        }

        final int totalBlog = data["count"] as int;
        if (totalBlog > _currentBlogsPage * _maxResourcePerPage) {
          _hasMoreBlogs = true;
        } else {
          _hasMoreBlogs = false;
        }
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> fetchVideos() async {
    try {
      if (_hasMoreVideos) {
        _currentVideosPage++;

        final response = await _apiService.get(auGetVideos, params: {
          'page': _currentVideosPage,
          'limit': _maxResourcePerPage,
          'access_token': _authenticationService.auth!.accessToken,
        });

        final data = constructResponse(response.data);

        if (data!["status"] == "failure") {
          throw ErrorData.fromJson(data);
        }

        final _videosJson = data["data"] as List;

        for (final videoJson in _videosJson) {
          _videos.add(ResourceData.fromJson(videoJson));
        }

        final int totalVideos = data["count"] as int;
        if (totalVideos > _currentBlogsPage * _maxResourcePerPage) {
          _hasMoreVideos = true;
        } else {
          _hasMoreVideos = false;
        }
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }
}
