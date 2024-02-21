import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.data.freezed.dart';
part 'message.data.g.dart';

@freezed
class MessageData with _$MessageData {
  const factory MessageData({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'userId') required int senderId,
    @JsonKey(name: 'message') required String text,
    @JsonKey(name: 'updateDate') required String dateTime,
  }) = _MessageData;

  factory MessageData.fromJson(Map<String, dynamic> json) =>
      _$MessageDataFromJson(json);
}
