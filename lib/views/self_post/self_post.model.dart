import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/forum_thread.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.mixin.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/forum.service.dart';
import 'package:mysirani/views/forum/forum.argument.dart';
import 'package:mysirani/views/forum/forum.view.dart';
import 'package:mysirani/views/write_thread/write_thread.argument.dart';
import 'package:mysirani/views/write_thread/write_thread.view.dart';

class SelfPostModel extends ViewModel
    with SnackbarMixin, BottomSheetMixin, DialogMixin {
  // Services
  final ForumService _forumService = locator<ForumService>();

  // Data
  List<ForumThreadData> get threads => _forumService.selfPosts;

  // Actions
  Future<void> init() async {
    try {
      setLoading();
      await _forumService.fetchThreads(
        locator<AuthenticationService>().auth!.userId,
      );
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
    setIdle();
  }

  Future<void> threadOption(String action, ForumThreadData thread) async {
    switch (action) {
      case "EDIT":
        _editThread(thread);
        break;
      case "DELETE":
        _deleteThread(thread.data.id);
        break;
      case "REPORT":
        _reportThread(thread);
        break;
      case "ISSUE":
        _issueThread(thread);
        break;
    }
  }

  Future<void> _deleteThread(int threadId) async {
    try {
      setWidgetBusy("thread-$threadId");
      await _forumService.removeThread(threadId);
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: "Successfully deleated!",
          type: ESnackbarType.success,
        ),
      );
      setIdle();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
    unsetWidgetBusy("thread-$threadId");
  }

  Future<void> _editThread(ForumThreadData thread) async {
    try {
      await goto(WriteThreadView.tag, arguments: WriteThreadArgument(thread));
      setIdle();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }

  Future<void> _reportThread(ForumThreadData thread) async {
    try {
      final _formKey = GlobalKey<FormState>();
      final _controller = TextEditingController();

      final btmSheetResponse = await bottomSheet.showBottomSheet(
        BottomSheetRequest<List<BottomSheetFormPayload>>(
          type: BottomSheetType.form,
          title: "Report",
          formKey: _formKey,
          payload: [
            BottomSheetFormPayload(
              controller: _controller,
              hintText: "Write report...",
              validator: FieldValidator.isRequired,
            ),
          ],
        ),
      );

      if (btmSheetResponse.result) {
        dialog.showDialog(
          DialogRequest(
            type: DialogType.progressDialog,
            title: "Report posting...",
          ),
        );

        await _forumService.reportThread(thread.data.id,
            detail: _controller.text.trim());

        dialog.hideDialog();

        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Report posted!",
            type: ESnackbarType.success,
          ),
        );
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }

  Future<void> _issueThread(ForumThreadData thread) async {
    try {
      final _formKey = GlobalKey<FormState>();
      final _controller = TextEditingController();

      final btmSheetResponse = await bottomSheet.showBottomSheet(
        BottomSheetRequest<List<BottomSheetFormPayload>>(
          type: BottomSheetType.form,
          title: "Post an issue",
          formKey: _formKey,
          payload: [
            BottomSheetFormPayload(
              controller: _controller,
              hintText: "Write your issue...",
              validator: FieldValidator.isRequired,
            ),
          ],
        ),
      );

      if (btmSheetResponse.result) {
        dialog.showDialog(
          DialogRequest(
            type: DialogType.progressDialog,
            title: "Report posting...",
          ),
        );

        await _forumService.postAnIssueThread(thread.data.id,
            detail: _controller.text.trim());

        dialog.hideDialog();

        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Issue posted!",
            type: ESnackbarType.success,
          ),
        );
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }

  Future<void> setLike(int id) async {
    try {
      setWidgetBusy("$id-like-btn");
      await _forumService.toggleThreadLike(id);
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
    unsetWidgetBusy("$id-like-btn");
  }

  Future<void> onForumThreadClick(ForumThreadData thread) async {
    await goto(ForumView.tag, arguments: ForumArgument(thread));
    setIdle();
  }
}
