import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource.data.freezed.dart';
part 'resource.data.g.dart';

/*
"id": 7,
      "blogs_name": "Missing Content | Episode 1 | Missing Counselor",
      "slug": "missing-content-episode-1-missing-counselor",
      "image": "1798618338Screen Shot 2021-06-04 at 6.38.09 PM.png",
      "blogs_desc": "<p>Our Co-Founder of TEDx</p>\r\n",
      "added_date": "2021-06-02",
      "status": "1",
      "trending": null,
      "feature": 0,
      "display_order": null,
      "youtube": "https://www.youtube.com/watch?v=my0YXyU15ow"
      */

@freezed
class ResourceData with _$ResourceData {
  const factory ResourceData({
    required int id,
    @JsonKey(name: "blogs_name") required String blogsName,
    required String slug,
    required String image,
    @JsonKey(name: "blogs_desc") required String blogsDesc,
    @JsonKey(name: "added_date") required String addedDate,
    String? youtube,
  }) = _ResourceData;

  factory ResourceData.fromJson(Map<String, dynamic> json) =>
      _$ResourceDataFromJson(json);
}
