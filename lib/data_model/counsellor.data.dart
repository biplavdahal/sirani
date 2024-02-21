import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysirani/data_model/counsellor_schedule.data.dart';
import 'package:mysirani/data_model/counsellor_review.data.dart';
import 'package:mysirani/data_model/user.data.dart';

part 'counsellor.data.freezed.dart';
part 'counsellor.data.g.dart';

@freezed
class CounsellorData with _$CounsellorData {
  const factory CounsellorData({
    int? rate,
    @JsonKey(name: "counselor") required UserData profile,
    @JsonKey(name: "ratting") required int rating,
    @JsonKey(name: "total_session") required String totalSession,
    @Default([]) List likes,
    @JsonKey(name: "userliked") String? hasLiked,
    required String status,
    @Default([]) List<CounsellorScheduleData> schedules,
    @JsonKey(name: "CounselorReviews")
    @Default([])
        List<CounsellorReviewData>? reviews,
  }) = _CounsellorData;

  factory CounsellorData.fromJson(Map<String, dynamic> json) =>
      _$CounsellorDataFromJson(json);
}
