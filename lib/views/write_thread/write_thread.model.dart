import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/forum_thread.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/forum.service.dart';
import 'package:mysirani/views/write_thread/write_thread.argument.dart';

class WriteThreadModel extends ViewModel with SnackbarMixin, DialogMixin {
  // Service
  final ForumService _forumService = locator<ForumService>();

  // UI Components
  final GlobalKey<FormState> _writeThreadFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get writeThreadFormKey => _writeThreadFormKey;
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;

  // Data
  ForumThreadData? _currentThread;
  ForumThreadData? get currentThread => _currentThread;

  bool _isAnonymous = false;
  bool get isAnonymous => _isAnonymous;
  set isAnonymous(bool value) {
    _isAnonymous = value;
    setIdle();
  }

  // Actions
  void init(WriteThreadArgument? argument) {
    if (argument != null) {
      _currentThread = argument.thread;
      _descriptionController.text = _currentThread!.data.description;
      _isAnonymous = _currentThread!.data.isAnonymous != null &&
          _currentThread!.data.isAnonymous == 1;
      setIdle();
    }
  }

  Future<void> onSharePressed() async {
    try {
      if (_writeThreadFormKey.currentState!.validate()) {
        dialog.showDialog(
          DialogRequest(
              type: DialogType.progressDialog, title: "Please wait..."),
        );
        await _forumService.addThread(
          _descriptionController.text.trim(),
          _isAnonymous,
        );
        dialog.hideDialog();
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Feeling shared!",
            type: ESnackbarType.success,
          ),
        );

        goBack();
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }

  Future<void> onUpdatePressed() async {
    try {
      if (_writeThreadFormKey.currentState!.validate()) {
        dialog.showDialog(
          DialogRequest(
              type: DialogType.progressDialog, title: "Please wait..."),
        );
        await _forumService.editThread(
          _descriptionController.text.trim(),
          _isAnonymous,
          _currentThread!.data.id,
        );
        dialog.hideDialog();
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Feeling updated!",
            type: ESnackbarType.success,
          ),
        );

        goBack();
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }
}
