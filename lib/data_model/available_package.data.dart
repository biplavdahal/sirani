import 'package:freezed_annotation/freezed_annotation.dart';

part 'available_package.data.freezed.dart';
part 'available_package.data.g.dart';

@freezed
class AvailablePackageData with _$AvailablePackageData {
  const factory AvailablePackageData({
    @JsonKey(name: "order_date") required String orderDate,
    @JsonKey(name: "valid_date") required String validityDate,
    @JsonKey(name: "order_rate") required String amount,
    @Default("") String title,
  }) = _AvailablePackageData;

  factory AvailablePackageData.fromJson(Map<String, dynamic> json) => _$AvailablePackageDataFromJson(json);
}