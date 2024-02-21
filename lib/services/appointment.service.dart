import 'package:mysirani/data_model/appointment.data.dart';
import 'package:mysirani/data_model/session_time.data.dart';
import 'package:mysirani/data_model/survey_answer.data.dart';
import 'package:mysirani/data_model/survey_question.data.dart';

abstract class AppointmentService {
  /// Getter for all available appointments
  List<AppointmentData> get appointments;

  /// Fetch all appointments
  Future<void> fetchAppointments();

  /// Update appointment
  void updateAppointment(AppointmentData appointment);

  /// Getter to get the counsellor id of on process booking.
  /// This will return the id of counselor to the user who, he/she (user), was on process of booking.
  int get counsellorIdToBeBooking;

  /// Setter to set the counsellor id of on process booking.
  void setCounsellorIdToBeBooking(int id);

  /// Reset all appointments
  void reset();

  /// Get survey answers
  Future<List<SurveyAnswerData>> getSurveyAnswers(int? userId);

  /// Get survey questions
  /// This method will return [List<SurveyQuestionData>] for user.
  /// If the survey has already been taken by the user, in such condition,
  /// this method will return empty list.
  Future<List<SurveyQuestionData>> getSurveyQuestions();

  /// Returns true if users has added attachement to the survey
  Future<bool> surveyHasAttachement();

  /// Uploads survey document
  Future<void> uploadSurveyDocument(String base64);

  /// Book appointment
  Future<void> bookAppointment({
    required int counsellorId,
    required String time,
    required String date,
    required String type,
    required String detail,
  });

  /// Approves or declines appointment
  Future<void> approveOrDeclineAppointment(
    int appointmentId, {
    bool isApproved = true,
  });

  /// Post survey answers
  Future<void> postSurveyAnswers(List<Map<String, dynamic>> answers);

  /// Extend time
  Future<void> extendSession({
    required String time,
    required int id,
  });

  /// Get session remaining minutes
  /// This method will return the remaining minutes of the session.
  Future<SessionTimeData> getSessionRemainigDuration(int callerId);
}
