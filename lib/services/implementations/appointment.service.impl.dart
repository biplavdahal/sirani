import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/appointment.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/session_time.data.dart';
import 'package:mysirani/data_model/survey_answer.data.dart';
import 'package:mysirani/data_model/survey_question.data.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/services/authentication.service.dart';

class AppointmentServiceImplementation implements AppointmentService {
  // Services
  final ApiService _apiService = locator<ApiService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  late int _counsellorIdToBeBooking;
  @override
  int get counsellorIdToBeBooking => _counsellorIdToBeBooking;
  @override
  void setCounsellorIdToBeBooking(int value) {
    _counsellorIdToBeBooking = value;
  }

  final List<AppointmentData> _appointments = [];
  @override
  List<AppointmentData> get appointments => _appointments;

  @override
  Future<void> fetchAppointments() async {
    _appointments.clear();
    try {
      final response = await _apiService.get(auGetAppointments, params: {
        'access_token': _authenticationService.auth!.accessToken,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      if (data["data"] is String) {
        throw const ErrorData(
            response: "You haven't booked any appointments yet.");
      }

      final _appointmentsJson = data["data"] as List;

      for (final _appointmentJson in _appointmentsJson) {
        _appointments.add(AppointmentData.fromJson(_appointmentJson));
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  void reset() {
    _appointments.clear();
  }

  @override
  void updateAppointment(AppointmentData data) {
    final _index = _appointments.indexWhere(
      (element) => element.info.appointmentId == data.info.appointmentId,
    );

    _appointments[_index] = data;
  }

  @override
  Future<List<SurveyAnswerData>> getSurveyAnswers(int? userId) async {
    try {
      final response = await _apiService.get(auGetSurveyAnswer, params: {
        'access_token': _authenticationService.auth!.accessToken,
        'user_id': userId ?? _authenticationService.auth!.userId,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      final _surveyAnswersJson = data["data"] as List;

      final _surveyAnswers = <SurveyAnswerData>[];

      for (final _surveyAnswerJson in _surveyAnswersJson) {
        if (_surveyAnswerJson["question_id"] != null) {
          _surveyAnswers.add(SurveyAnswerData.fromJson(_surveyAnswerJson));
        }
      }

      return _surveyAnswers;
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<List<SurveyQuestionData>> getSurveyQuestions() async {
    try {
      final response = await _apiService.get(auGetSurveyQuestions, params: {
        'access_token': _authenticationService.auth!.accessToken,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }
      final _surveyQuestionsJson = data["data"] as List;
      final _surveyQuestions = <SurveyQuestionData>[];

      if ((data["survey_taken"] as List).isEmpty) {
        for (final _surveyQuestionJson in _surveyQuestionsJson) {
          _surveyQuestions
              .add(SurveyQuestionData.fromJson(_surveyQuestionJson));
        }
      } else {
        final _surveyQuestionsTaken = data["survey_taken"] as List;

        for (final _surveyQuestionJson in _surveyQuestionsJson) {
          final _hasTaken = _surveyQuestionsTaken.firstWhere(
              (question) =>
                  question["question_id"] == _surveyQuestionJson["id"],
              orElse: () => null);
          if (_hasTaken == null) {
            _surveyQuestions.add(
              SurveyQuestionData.fromJson(_surveyQuestionJson),
            );
          }
        }
      }

      return _surveyQuestions;
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<bool> surveyHasAttachement() async {
    try {
      final response = await _apiService.get(auGetSurveyQuestions, params: {
        'access_token': _authenticationService.auth!.accessToken,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      if ((data["survey_taken"] as List).isEmpty) {
        return false;
      } else {
        final _surveyQuestionsTaken = data["survey_taken"] as List;
        final _hasTaken = _surveyQuestionsTaken.firstWhere(
            (question) =>
                question["question_id"] == 0 &&
                question["useroption"] != null &&
                (question["useroption"] as String).contains("."),
            orElse: () => null);
        return _hasTaken != null;
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> uploadSurveyDocument(String base64) async {
    try {
      final response = await _apiService.post(auUploadSurveyDocument, {
        'access_token': _authenticationService.auth!.accessToken,
        'image': base64,
        'id': 0,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> bookAppointment({
    required int counsellorId,
    required String time,
    required String date,
    required String type,
    required String detail,
  }) async {
    try {
      final response = await _apiService.post(auAddAppointment, {
        'access_token': _authenticationService.auth!.accessToken,
        'counselor_id': counsellorId,
        'time': time,
        'date': date,
        'type': type,
        'detail': detail,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      if (data["status"] is bool && !data["status"]) {
        throw ErrorData(response: data["detail"]);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> approveOrDeclineAppointment(int appointmentId,
      {bool isApproved = true}) async {
    try {
      final response = await _apiService.post(auAppointmentAction, {
        'access_token': _authenticationService.auth!.accessToken,
        'id': appointmentId,
        'status': isApproved ? "Approved" : "Declined",
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> postSurveyAnswers(List<Map<String, dynamic>> answers) async {
    try {
      final response = await _apiService.post(auSaveSurvey, {
        'access_token': _authenticationService.auth!.accessToken,
        'question': answers,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      if (data["status"] is bool && !data["status"]) {
        throw ErrorData(response: data["detail"]);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> extendSession({required String time, required int id}) async {
    try {
      debugPrint({
        'access_token': _authenticationService.auth!.accessToken,
        'id': id,
        'end_time': time,
      }.toString());

      final response = await _apiService.post(auSessionExtend, {
        'access_token': _authenticationService.auth!.accessToken,
        'id': id,
        'end_time': time,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      if (data["status"] is bool && !data["status"]) {
        throw ErrorData(response: data["detail"]);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<SessionTimeData> getSessionRemainigDuration(int callerId) async {
    try {
      final response = await _apiService.post(auSessionEndTime, {
        'access_token': _authenticationService.auth!.accessToken,
        'id': callerId,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      if (data["status"] is bool && !data["status"]) {
        throw ErrorData(response: data["detail"]);
      }

      return SessionTimeData.fromJson({
        "remaining_duration": durationFromDouble(data["end_time"]),
        "end_time": data["data"]["end_time"]
      });
    } on DioError catch (e) {
      throw dioError(e);
    }
  }
}
