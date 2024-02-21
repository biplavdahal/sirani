import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/free_session.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/user.service.dart';

class ProfileModel extends ViewModel with SnackbarMixin {
  // Services
  final UserService _userService = locator<UserService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  // UI Components / Controllers
  // ...

  // Data
  FreeSessionData? _freeSession;
  FreeSessionData? get freeSession => _freeSession;

  // Actions
  Future<void> init() async {
    try {
      if (locator<AuthenticationService>().isNormalUser) {
        setWidgetBusy("user-stats");
        _freeSession = await _userService.getFreeSessions();
        unsetWidgetBusy("user-stats");
      }
    } on ErrorData catch (e) {
      unsetWidgetBusy("user-stats");

      errorHandler(snackbar, e: e);
    }
  }

  Future<void> refreshAmount() async {
    try {
      setWidgetBusy("user-amount");
      await _authenticationService.updateBalance();
      unsetWidgetBusy("user-amount");
    } on ErrorData catch (e) {
      unsetWidgetBusy("user-amount");

      errorHandler(snackbar, e: e);
    }
  }
}
