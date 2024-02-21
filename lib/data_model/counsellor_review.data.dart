import 'package:freezed_annotation/freezed_annotation.dart';

part 'counsellor_review.data.freezed.dart';
part 'counsellor_review.data.g.dart';

@freezed
class CounsellorReviewData with _$CounsellorReviewData {
  const factory CounsellorReviewData({
    @JsonKey(name: 'review_id') required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'ratting') required String rating,
    required String name,
    required String review,
    @JsonKey(name: 'datetime') required String dateTime,
  }) = _CounsellorReviewData;

  factory CounsellorReviewData.fromJson(Map<String, dynamic> json) =>
      _$CounsellorReviewDataFromJson(json);
}
