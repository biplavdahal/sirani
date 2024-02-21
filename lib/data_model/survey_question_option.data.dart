import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_question_option.data.freezed.dart';
part 'survey_question_option.data.g.dart';

@freezed
class SurveyQuestionOptionData with _$SurveyQuestionOptionData {
  const factory SurveyQuestionOptionData({
    required int id,
    required String text,
  }) = _SurveyQuestionOptionData;

  factory SurveyQuestionOptionData.fromJson(Map<String, dynamic> json) => _$SurveyQuestionOptionDataFromJson(json);
}
