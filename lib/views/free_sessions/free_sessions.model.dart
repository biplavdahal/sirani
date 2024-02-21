import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/mixins/snack_bar.mixin.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/user.service.dart';
import 'package:mysirani/data_model/free_session_thread.data.dart';

class FreeSessionsModel extends ViewModel with SnackbarMixin {
  // Services
  final UserService _userService = locator<UserService>();

  // Data
  List<FreeSessionThreadData> get freeSessionThreads =>
      _userService.freeSessionThreads;

  // Actions
  Future<void> init() async {
    try {
      setLoading();
      await _userService.fetchFreeSessionThreads();

      if (_userService.freeSessionThreads.isEmpty) {
        SnackbarRequest.of(
          message: "No sessions available!",
          type: ESnackbarType.warning,
          duration: ESnackbarDuration.long,
        );
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }
}
