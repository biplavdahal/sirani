import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/feeling.data.dart';
import 'package:mysirani/data_model/forum_thread.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.mixin.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/forum.service.dart';
import 'package:mysirani/services/user.service.dart';
import 'package:mysirani/views/dashboard/dashboard.model.dart';
import 'package:mysirani/views/forum/forum.argument.dart';
import 'package:mysirani/views/forum/forum.view.dart';
import 'package:mysirani/views/write_thread/write_thread.argument.dart';
import 'package:mysirani/views/write_thread/write_thread.view.dart';

class HomeModel extends ViewModel
    with SnackbarMixin, DialogMixin, BottomSheetMixin {
  // Services
  final ForumService _forumService = locator<ForumService>();
  final UserService _userService = locator<UserService>();

  // UI Components
  final ScrollController _forumThreadsScrollControrller = ScrollController();
  ScrollController get forumThreadsScrollControrller =>
      _forumThreadsScrollControrller;

  // Data
  FeelingData? get feeling => _userService.feeling;
  List<ForumThreadData>? get threads => _forumService.threads;
  bool get canLoadMore => _forumService.canLoadMore;

  // Actions
  Future<void> init({bool refresh = false}) async {
    try {
      setAlert(viewState: EState.error, message: "");
      setWidgetBusy("threads-list");
      setWidgetBusy("feelings");

      if (locator<AuthenticationService>().isNormalUser) {
        await _userService.fetchFeeling();
      }
      unsetWidgetBusy("feelings");

      if (refresh) {
        _forumService.reset();
      }

      await _forumService.fetchThreads(null);
      unsetWidgetBusy("threads-list");
      if (_forumThreadsScrollControrller.hasListeners == false) {
        _forumThreadsScrollControrller.addListener(() async {
          if (_forumThreadsScrollControrller.position.atEdge) {
            if (_forumThreadsScrollControrller.position.pixels != 0) {
              await _forumService.fetchThreads(null);
              setIdle();
            }
          }
        });
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);

      setAlert(viewState: EState.error, message: e.response);
    }
  }

  Future<void> setFeeling(String mood) async {
    try {
      dialog.showDialog(
        DialogRequest(
          type: DialogType.progressDialog,
          title: "Please wait...",
        ),
      );

      await _userService.setFeeling(mood);

      dialog.hideDialog();
      setIdle();

      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: "Mood updated!",
          type: ESnackbarType.success,
        ),
      );
    } on ErrorData catch (e) {
      dialog.hideDialog();
      if (e.response == "Invalid Access Token") {
        locator<DashboardModel>().moreActions("logout");
        return;
      }
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.response,
          type: ESnackbarType.error,
        ),
      );
    }
  }

  Future<void> setLike(int id) async {
    try {
      setWidgetBusy("$id-like-btn");
      await _forumService.toggleThreadLike(id);
      unsetWidgetBusy("$id-like-btn");
    } on ErrorData catch (e) {
      unsetWidgetBusy("$id-like-btn");

      if (e.response == "Invalid Access Token") {
        locator<DashboardModel>().moreActions("logout");
        return;
      }
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.response.toString(),
          type: ESnackbarType.error,
        ),
      );
    }
  }

  Future<void> onForumThreadClick(ForumThreadData thread) async {
    await goto(ForumView.tag, arguments: ForumArgument(thread));
    setIdle();
  }

  Future<void> onShareFeelingPressed() async {
    await goto(WriteThreadView.tag);
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
      if (e.response == "Invalid Access Token") {
        locator<DashboardModel>().moreActions("logout");
        return;
      }
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.response,
          type: ESnackbarType.error,
        ),
      );
    }
    unsetWidgetBusy("thread-$threadId");
  }

  Future<void> _editThread(ForumThreadData thread) async {
    try {
      await goto(WriteThreadView.tag, arguments: WriteThreadArgument(thread));
      setIdle();
    } on ErrorData catch (e) {
      if (e.response == "Invalid Access Token") {
        locator<DashboardModel>().moreActions("logout");
        return;
      }
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.response,
          type: ESnackbarType.error,
        ),
      );
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
      if (e.response == "Invalid Access Token") {
        locator<DashboardModel>().moreActions("logout");
        return;
      }
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.response,
          type: ESnackbarType.error,
        ),
      );
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
      if (e.response == "Invalid Access Token") {
        locator<DashboardModel>().moreActions("logout");
        return;
      }
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.response,
          type: ESnackbarType.error,
        ),
      );
    }
  }
}
