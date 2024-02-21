import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/message.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/chat.service.dart';
import 'package:mysirani/views/message_board/message_board.argument.dart';

class MessageBoardModel extends ViewModel with SnackbarMixin {
  // Service
  final ChatService _chatService = locator<ChatService>();

  // UI Controllers

  final TextEditingController _messageController = TextEditingController();
  TextEditingController get messageController => _messageController;

  // Data

  List<MessageData> _messages = [];
  List<MessageData> get messages => _messages;

  late String _receiverName;
  String get receiverName => _receiverName;
  late int _receiverId;
  int get receiverId => _receiverId;

  bool _enableSendButton = false;
  bool get enableSendButton => _enableSendButton;

  int? _showDateTimeFor;
  bool showDateTime(int id) {
    return _showDateTimeFor != null && _showDateTimeFor == id;
  }

  set showDateTimeFor(int id) {
    if (_showDateTimeFor != id) {
      _showDateTimeFor = id;
    } else {
      _showDateTimeFor = null;
    }
    setIdle();
  }

  // Action
  Future<void> init(MessageBoardArgument argument) async {
    _receiverId = argument.receiverId;
    _receiverName = argument.receiverName;
    setIdle();

    try {
      setLoading();

      _messages = await _chatService.messages(receiverId);

      setIdle();

      _chatService.messagesStreamController.stream.listen(
        (messages) {
          _messages = messages;
          setIdle();
        },
      );

      if (!_messageController.hasListeners) {
        _messageController.addListener(() {
          _enableSendButton = _messageController.text.trim().isNotEmpty;
          setIdle();
        });
      }
    } on ErrorData catch (e) {
      setIdle();

      errorHandler(snackbar, e: e);
      goBack();
    }
  }

  @override
  void dispose() {
    _chatService.stopMessageStream();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    try {
      setWidgetBusy('send-btn');
      final message = await _chatService.sendMessage(
        receiverId: _receiverId,
        message: _messageController.text.trim(),
      );
      unsetWidgetBusy('send-btn');
      _messages.insert(0, message);
      _messageController.clear();
    } on ErrorData catch (e) {
      setIdle();
      errorHandler(snackbar, e: e);
      goBack();
    }
  }
}
