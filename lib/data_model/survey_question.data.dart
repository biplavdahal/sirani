import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysirani/data_model/survey_question_option.data.dart';

part 'survey_question.data.freezed.dart';
part 'survey_question.data.g.dart';

@freezed
class SurveyQuestionData with _$SurveyQuestionData {
  const factory SurveyQuestionData({
    required int id,
    @JsonKey(name: "question_title") required String question,
    required List<SurveyQuestionOptionData> options,
  }) = _SurveyQuestionData;

  factory SurveyQuestionData.fromJson(Map<String, dynamic> json) =>
      _$SurveyQuestionDataFromJson(json);
}
