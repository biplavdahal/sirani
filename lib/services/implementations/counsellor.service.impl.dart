import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/counsellor.data.dart';
import 'package:mysirani/data_model/counsellor_review.data.dart';
import 'package:mysirani/data_model/counsellor_schedule.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/user.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/counsellor.service.dart';

class CounsellorServiceImplementation implements CounsellorService {
  // Services
  final ApiService _apiService = locator<ApiService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final Map<String, bool> _loaded = {
    "buddies": false,
    "counselor": false,
    "volunteer_counselor": false,
  };

  final Map<String, List<CounsellorData>?> _counsellors = {
    "buddies": null,
    "counselor": null,
    "volunteer_counselor": null,
  };
  @override
  Map<String, List<CounsellorData>?> get counsellors => _counsellors;

  @override
  Future<void> fetchRoles(String role) async {
    try {
      if (_loaded[role] == true) return;

      final response = await _apiService.get(auCounsellorList, params: {
        'role': role,
        'access_token': _authenticationService.auth!.accessToken
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      if (data["status"] is String) return;

      final _dataCounsellors = <CounsellorData>[];

      final _counsellorsJson = data["data"] as List;

      for (final _counsellorJson in _counsellorsJson) {
        _dataCounsellors.add(CounsellorData.fromJson(_counsellorJson));
      }

      _counsellors[role] = _dataCounsellors;

      _loaded[role] = true;
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<CounsellorData> fetchCounsellorProfile(int id) async {
    try {
      final response = await _apiService.post(auCounsellorProfile, {}, params: {
        "access_token": _authenticationService.auth!.accessToken,
        "counselor_id": id
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final _c = CounsellorData.fromJson(data["data"]);

      if (locator<AuthenticationService>().auth!.userId == id) {
        _counsellorSchedules = _c.schedules;
      }
      return _c;
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> addLike(
    int id, {
    required String role,
  }) async {
    try {
      final response = await _apiService.post(auCounsellorLike, {
        "access_token": _authenticationService.auth!.accessToken,
        "counselor_id": id
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final index = _counsellors[role]!.indexWhere((c) => c.profile.id == id);

      _counsellors[role]![index] = _counsellors[role]![index].copyWith(
        hasLiked: "Yes",
      );

      _counsellors[role]![index].likes.add(data["data"]);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<CounsellorReviewData> addReview(
    int id, {
    required String review,
    required double rating,
  }) async {
    try {
      final response = await _apiService.post(auCounsellorRating, {
        "access_token": _authenticationService.auth!.accessToken,
        "counselor_id": id,
        "review": review,
        "ratting": rating.toString(),
        "name": _authenticationService.auth!.user.fullName,
        "email": _authenticationService.auth!.user.email,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      return CounsellorReviewData.fromJson(data["data"]);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> fetchCounsellorSchedule() async {
    try {
      final response = await _apiService.post(auCounsellorProfile, {}, params: {
        "access_token": _authenticationService.auth!.accessToken,
        "counselor_id": _authenticationService.auth!.userId
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final _c = CounsellorData.fromJson(data["data"]);
      _counsellorSchedules = _c.schedules;
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  List<CounsellorScheduleData>? _counsellorSchedules;
  @override
  List<CounsellorScheduleData>? get counsellorSchedules => _counsellorSchedules;

  @override
  Future<void> removeSchedule(int id) async {
    try {
      final response = await _apiService.post(auCounsellorScheduleRemove,
          {"access_token": _authenticationService.auth!.accessToken, "id": id});

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final index = _counsellorSchedules!.indexWhere((c) => c.id == id);

      _counsellorSchedules!.removeAt(index);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> addSchedule(
      {required String weekday,
      required String fromTime,
      required String toTime}) async {
    try {
      final response = await _apiService.post(auCounsellorScheduleAdd, {
        "access_token": _authenticationService.auth!.accessToken,
        "days": weekday,
        "from_time": fromTime,
        "to_time": toTime,
        "status": "Active"
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      _counsellorSchedules!.add(CounsellorScheduleData.fromJson(data["data"]));
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> updateSchedule({
    required String weekday,
    required String fromTime,
    required String toTime,
    required String status,
    required int id,
  }) async {
    try {
      final response = await _apiService.post(auCounsellorScheduleEdit, {
        "access_token": _authenticationService.auth!.accessToken,
        "days": weekday,
        "from_time": fromTime,
        "to_time": toTime,
        "status": status,
        "id": id
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final index = _counsellorSchedules!.indexWhere((c) => c.id == id);

      _counsellorSchedules![index] =
          CounsellorScheduleData.fromJson(data["data"]);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  void clearScheduleCache() {
    _counsellorSchedules = null;
  }

  final List<UserData> _chats = [];
  @override
  List<UserData> get chats => _chats;

  @override
  Future<void> fetchChatsList() async {
    try {
      final response = await _apiService.post(auCounsellorChatList, {
        "access_token": _authenticationService.auth!.accessToken,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      _chats.clear();

      for (final chat in data["data"]) {
        _chats.add(UserData.fromJson(chat["user"]));
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }
}
