import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_plan.data.freezed.dart';
part 'chat_plan.data.g.dart';

@freezed
class ChatPlanData with _$ChatPlanData {
  const factory ChatPlanData({
    @JsonKey(name: "chat_plan_id") required int id,
    required String title,
    required int rate,
    @JsonKey(name: "discount_rate") int? discountRate,
    @JsonKey(name: "discount_percent") int? discountPercent,
    required int sessions,
    required int time,
    @JsonKey(name: "time_unit") required String timeUnit,
    required String support,
    required String category,
    required String type,
  }) = _ChatPlanData;

  factory ChatPlanData.fromJson(Map<String, dynamic> json) =>
      _$ChatPlanDataFromJson(json);
}
