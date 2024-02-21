import 'package:mysirani/data_model/available_package.data.dart';
import 'package:mysirani/data_model/chat_plan.data.dart';
import 'package:mysirani/data_model/feeling.data.dart';
import 'package:mysirani/data_model/free_session.data.dart';
import 'package:mysirani/data_model/free_session_thread.data.dart';
import 'package:mysirani/data_model/user.data.dart';

abstract class UserService {
  /// Get the user's feeling.
  FeelingData? get feeling;

  /// Fetch feeling data from the server.
  Future<void> fetchFeeling();

  /// Clear feelings
  void clearFeeling();

  /// Getter for user's free session threads.
  List<FreeSessionThreadData> get freeSessionThreads;

  /// fetch free session threads
  Future<void> fetchFreeSessionThreads();

  /// Set user feeling
  Future<void> setFeeling(String mood);

  /// Get free sessions for the user
  Future<FreeSessionData?> getFreeSessions();

  /// Change password
  Future<void> changePassword(String password);

  /// Get Avaialble Packages
  Future<List<AvailablePackageData>> getPackages();

  /// Get available chat plans
  Future<List<ChatPlanData>> getChatPlans();

  /// Update user/counsellor profile
  Future<void> updateProfile(UserData data);

  /// Buy chat
  Future<void> buyChatPlanWithBalance(int chatPlanId);

}
