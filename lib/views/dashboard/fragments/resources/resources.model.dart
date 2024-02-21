import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/resource.service.dart';
import 'package:mysirani/data_model/resource.data.dart';
import 'package:mysirani/views/resource/resource.argument.dart';
import 'package:mysirani/views/resource/resource.view.dart';
import 'package:mysirani/views/resource_list/resource_list.argument.dart';
import 'package:mysirani/views/resource_list/resource_list.view.dart';

class ResoucesModel extends ViewModel with SnackbarMixin {
  // Service
  final ResourceService _resourceService = locator<ResourceService>();

  // Data
  List<ResourceData> get blogs => _resourceService.blogs;
  List<ResourceData> get videos => _resourceService.videos;

  // Actions
  Future<void> init() async {
    try {
      setLoading();
      await _resourceService.fetchBlogs();
      await _resourceService.fetchVideos();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }

  void onResourcePressed(ResourceData resource) {
    goto(ResourceView.tag, arguments: ResourceArgument(resource));
  }

  void onViewMorePressed(String type) {
    goto(ResourceListView.tag, arguments: ResourceListAgument(type));
  }
}
