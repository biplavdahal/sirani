import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/available_package.data.dart';
import 'package:mysirani/data_model/chat_plan.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/feeling.data.dart';
import 'package:mysirani/data_model/free_session.data.dart';
import 'package:mysirani/data_model/free_session_thread.data.dart';
import 'package:mysirani/data_model/user.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/user.service.dart';

class UserServiceImplementation implements UserService {
  // Services
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ApiService _apiService = locator<ApiService>();

  FeelingData? _feeling;
  @override
  FeelingData? get feeling => _feeling;

  @override
  Future<void> fetchFeeling() async {
    try {
      final response = await _apiService.get(auGetUserFeeling, params: {
        "access_token": _authenticationService.auth!.accessToken,
      });

      final data = constructResponse(response.data);

      if (data!["status"] is bool) {
        if (data["status"]) {
          _feeling = FeelingData.fromJson(data);
        }

        return;
      } else {
        throw ErrorData.fromJson(data);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  void clearFeeling() {
    _feeling = null;
  }

  @override
  Future<void> setFeeling(String mood) async {
    try {
      final response = await _apiService.post(auUpdateUserFeeling, {
        "access_token": _authenticationService.auth!.accessToken,
        "feeling": mood,
      });

      final data = constructResponse(response.data);

      if (data!["status"] is bool) {
        if (data["status"]) {
          _feeling = FeelingData.fromJson(data);
        }

        return;
      } else {
        throw ErrorData.fromJson(data);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<FreeSessionData?> getFreeSessions() async {
    try {
      final response = await _apiService.get(auGetUserFreeSessions, params: {
        "access_token": _authenticationService.auth!.accessToken,
      });

      final data = constructResponse(response.data);

      if (data!["status"] is bool) {
        if (data["status"]) {
          return FreeSessionData.fromJson(data["data"]);
        }

        return null;
      }

      throw ErrorData.fromJson(data);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> changePassword(String password) async {
    try {
      final response = await _apiService.post(auChangePassword, {}, params: {
        "access_token": _authenticationService.auth!.accessToken,
        "password": password,
        "password_repeat": password,
        "user_id": _authenticationService.auth!.userId,
      });

      final data = constructResponse(response.data);

      if (data!["status"] is bool) {
        if (data["status"]) {
          return;
        }
      }

      throw ErrorData.fromJson(data);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<List<AvailablePackageData>> getPackages() async {
    try {
      final response = await _apiService.get(auAvailablePackages, params: {
        "access_token": _authenticationService.auth!.accessToken,
      });

      final data = constructResponse(response.data);

      if (data!["status"] is bool) {
        if (data["status"]) {
          return (data["data"] as List)
              .map((e) => AvailablePackageData.fromJson(e))
              .toList();
        }

        return [];
      }

      throw ErrorData.fromJson(data);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<List<ChatPlanData>> getChatPlans() async {
    try {
      final response = await _apiService.get(auChatPlans, params: {
        "access_token": _authenticationService.auth!.accessToken,
      });

      final data = constructResponse(response.data);

      if (data!["status"] is bool) {
        if (data["status"]) {
          return (data["data"] as List)
              .map((e) => ChatPlanData.fromJson(e))
              .toList();
        }

        return [];
      }

      throw ErrorData.fromJson(data);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> updateProfile(UserData data) async {
    try {
      final response = await _apiService.post(auUpdateProfile, {
        "access_token": _authenticationService.auth!.accessToken,
        ...data.toJson(),
      });

      final responseData = constructResponse(response.data);

      if (responseData!["status"] is bool) {
        if (responseData["status"]) {
          _authenticationService.updateUser(responseData["data"]);
          return;
        }
      }

      throw ErrorData.fromJson(responseData);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> buyChatPlanWithBalance(int chatPlanId) async {
    try {
      final response = await _apiService.post(auBuyChatPlan, {
        "access_token": _authenticationService.auth!.accessToken,
        "chat_plan_id": chatPlanId,
      });

      final responseData = constructResponse(response.data);

      if (responseData!["status"] is bool) {
        if (responseData["status"]) {
          await _authenticationService.updateBalance(
            -responseData["data"]["rate"] as int,
          );

          return;
        }
      }

      throw ErrorData.fromJson(responseData);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  final List<FreeSessionThreadData> _freeSessionThreads = [];
  @override
  List<FreeSessionThreadData> get freeSessionThreads => _freeSessionThreads;

  @override
  Future<void> fetchFreeSessionThreads() async {
    try {
      final response = await _apiService.get(auFreeSessionThreads, params: {
        "access_token": _authenticationService.auth!.accessToken,
      });

      final data = constructResponse(response.data);

      if (data!["status"] is bool) {
        if (data["status"]) {
          _freeSessionThreads.clear();

          final threadsJson = data["data"] as List;

          for (final threadJson in threadsJson) {
            _freeSessionThreads.add(FreeSessionThreadData.fromJson(threadJson));
          }

          return;
        }
      }

      throw ErrorData.fromJson(data);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  
}
