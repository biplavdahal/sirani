import 'dart:async';

import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/data_model/message.data.dart';

abstract class ChatService<T extends ApiService> {
  StreamController<List<MessageData>> get messagesStreamController;

  /// Stream messages
  Future<List<MessageData>> messages(int receiverId);

  /// Stop stream
  void stopMessageStream();

  /// Send message
  Future<MessageData> sendMessage({
    required int receiverId,
    required String message,
  });
}
