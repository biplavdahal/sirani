import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_answer.data.freezed.dart';
part 'survey_answer.data.g.dart';

@freezed
class SurveyAnswerData with _$SurveyAnswerData {
  const factory SurveyAnswerData({
    required int id,
    @JsonKey(name: "question_id") int? questionId,
    String? question,
    @JsonKey(name: "useroption") required String answer,
  }) = _SurveyAnswerData;

  factory SurveyAnswerData.fromJson(Map<String, dynamic> json) =>
      _$SurveyAnswerDataFromJson(json);
}
