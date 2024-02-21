import 'dart:async';

import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/message.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/chat.service.dart';

class ChatServiceImplementation<T extends ApiService> extends ChatService<T> {
  // Service
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final T _apiService = locator<T>();

  // Data
  late StreamController<List<MessageData>> _chatStreamController;
  late Timer? _timer;

  @override
  StreamController<List<MessageData>> get messagesStreamController =>
      _chatStreamController;

  Future<List<MessageData>> _fetchMessages(int receiverId) async {
    try {
      final response = await _apiService.get(auMessages, params: {
        'access_token': _authenticationService.auth!.accessToken,
        'sender_id': _authenticationService.auth!.user.id,
        'receiver_id': receiverId,
      });

      debugPrint({
        'access_token': _authenticationService.auth!.accessToken,
        'sender_id': _authenticationService.auth!.user.id,
        'receiverId': receiverId,
      }.toString());

      final data = constructResponse(response.data);

      debugPrint(data.toString());

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      if (data["status"] is bool) {
        if (!data["status"]) {
          throw const ErrorData(response: "Session might have ended!");
        }
      }

      List<MessageData> _messages = [];

      final threadsJson = data["data"] as List;

      for (final threadJson in threadsJson) {
        _messages.add(MessageData.fromJson(threadJson));
      }

      if (!_chatStreamController.isClosed) {
        _chatStreamController.add(_messages.reversed.toList());
      }

      return _messages.reversed.toList();
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<List<MessageData>> messages(int receiverId) async {
    try {
      _chatStreamController = StreamController<List<MessageData>>.broadcast();
      final data = await _fetchMessages(receiverId);

      Stopwatch watch = Stopwatch();
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        if (!watch.isRunning) {
          watch.start();
          await _fetchMessages(receiverId);
          watch.stop();
        }
      });

      return data;
    } on ErrorData catch (_) {
      rethrow;
    }
  }

  @override
  void stopMessageStream() {
    debugPrint("Message stream closed!");
    if (_timer != null) {
      _timer?.cancel();
    }
    _chatStreamController.close();
  }

  @override
  Future<MessageData> sendMessage(
      {required int receiverId, required String message}) async {
    try {
      final response = await _apiService.post(
          auSendMessage,
          {
            'access_token': _authenticationService.auth!.accessToken,
            'receiver_id': receiverId,
            'message': message,
          },
          asFormData: true);

      debugPrint({
        'access_token': _authenticationService.auth!.accessToken,
        'receiver_id': receiverId,
        'message': message,
      }.toString());

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      if (data["status"] is bool) {
        if (!data["status"]) {
          throw const ErrorData(response: "Session might have ended!");
        }
      }

      return MessageData.fromJson(data["data"]);
    } on DioError catch (e) {
      throw dioError(e);
    }
  }
}
