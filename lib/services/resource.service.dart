import 'package:mysirani/data_model/resource.data.dart';

abstract class ResourceService {
  /// Getter for all blog resource
  List<ResourceData> get blogs;

  /// Returns true if there is more blogs to be loaded
  bool get hasMoreBlogs;

  /// Getter for all video resource
  List<ResourceData> get videos;

  /// Returns true if there is more videos to be loaded
  bool get hasMoreVideos;

  /// Fetch all blogs
  Future<void> fetchBlogs();

  /// Fetch all videos
  Future<void> fetchVideos();

  /// Reset everything
  void reset(String type);
}
