import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/resource.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/resource.service.dart';
import 'package:mysirani/views/resource_list/resource_list.argument.dart';

class ResourceListModel extends ViewModel with SnackbarMixin {
  // Services
  final ResourceService _resourceService = locator<ResourceService>();

  // UI Controllers
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  // Data
  String _type = "blog";
  String get type => _type;

  bool get canLoadMore => _type == "blog"
      ? _resourceService.hasMoreBlogs
      : _resourceService.hasMoreVideos;
  List<ResourceData> get resources =>
      _type == "blog" ? _resourceService.blogs : _resourceService.videos;

  Future<void> init(ResourceListAgument? arguments) async {
    _type = arguments?.type ?? "blog";
    setIdle();

    if (!scrollController.hasListeners) {
      scrollController.addListener(() async {
        if (_scrollController.position.atEdge) {
          if (_scrollController.position.pixels != 0) {
            if (_type == "blog") {
              await _resourceService.fetchBlogs();
            }

            if (_type == "video") {
              await _resourceService.fetchVideos();
            }

            setIdle();
          }
        }
      });
    }
  }

  Future<void> onRefresh() async {
    try {
      setLoading();
      _resourceService.reset(_type);

      if (_type == "blog") {
        await _resourceService.fetchBlogs();
      }

      if (_type == "video") {
        await _resourceService.fetchVideos();
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }
}
