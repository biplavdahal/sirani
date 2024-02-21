import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/data_model/available_package.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/user.service.dart';

class UserPackageModel extends ViewModel with SnackbarMixin {
  // Services
  final UserService _userService = locator<UserService>();

  // Data
  List<AvailablePackageData> _availablePackages = [];
  List<AvailablePackageData> get availablePackages => _availablePackages;

  // Actions
  Future<void> init() async {
    try {
      setLoading();
      _availablePackages = await _userService.getPackages();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }
}
