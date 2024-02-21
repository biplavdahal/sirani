import 'package:mysirani/data_model/counsellor.data.dart';
import 'package:mysirani/data_model/counsellor_review.data.dart';
import 'package:mysirani/data_model/counsellor_schedule.data.dart';
import 'package:mysirani/data_model/user.data.dart';

abstract class CounsellorService {
  /// Get all counsellors
  Map<String, List<CounsellorData>?> get counsellors;

  /// Getter for counsellor's schedule
  List<CounsellorScheduleData>? get counsellorSchedules;

  /// Fetch roles
  Future<void> fetchRoles(String role);

  /// Fetch complete profile of counsellor
  Future<CounsellorData> fetchCounsellorProfile(int id);

  /// Add like to the counsellor profile
  Future<void> addLike(
    int id, {
    required String role,
  });

  /// Add review to the counsellor profile
  Future<CounsellorReviewData> addReview(
    int id, {
    required String review,
    required double rating,
  });

  /// Fetch counsellor's schedule
  Future<void> fetchCounsellorSchedule();

  /// Remove schedule
  Future<void> removeSchedule(int id);

  /// Add time slot to counsellor's schedule
  Future<void> addSchedule({
    required String weekday,
    required String fromTime,
    required String toTime,
  });

  /// Update time slot to counsellor's schedule
  Future<void> updateSchedule({
    required String weekday,
    required String fromTime,
    required String toTime,
    required String status,
    required int id,
  });

  /// Clear schedule cache locally after logout.
  void clearScheduleCache();

  /// Getter for chats list
  List<UserData> get chats;

  /// Fetch all chats list of counsellor
  Future<void> fetchChatsList();
}
