import 'package:freezed_annotation/freezed_annotation.dart';

part 'statement.data.freezed.dart';
part 'statement.data.g.dart';

@freezed
class StatementData with _$StatementData {
  const factory StatementData({
    @JsonKey(name: 'account_balance_id') required int id,
    required int amount,
    required String type,
    required String source,
    @JsonKey(name: 'datetime') required String dateTime,
  }) = _StatementData;

  factory StatementData.fromJson(Map<String, dynamic> json) =>
      _$StatementDataFromJson(json);
}
