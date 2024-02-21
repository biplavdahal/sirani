import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/survey_answer.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/views/view_survey/view_survey.argument.dart';

class ViewSurveyModel extends ViewModel with SnackbarMixin {
  // Services
  final AppointmentService _appointmentService = locator<AppointmentService>();

  // Data
  late List<SurveyAnswerData> _surveyQuestions;
  List<SurveyAnswerData> get surveyQuestions => _surveyQuestions;

  // Actions
  Future<void> init(ViewSurveyArgument argument) async {
    try {
      setLoading();
      _surveyQuestions =
          await _appointmentService.getSurveyAnswers(argument.userId);
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }
}
