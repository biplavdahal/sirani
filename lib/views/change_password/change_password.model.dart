import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/user.service.dart';

class ChangePasswordModel extends ViewModel with DialogMixin, SnackbarMixin {
  // Services
  final UserService _userService = locator<UserService>();

  // UI components
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final TextEditingController _newPasswordController = TextEditingController();
  TextEditingController get newPasswordController => _newPasswordController;
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  // Data
  // ...

  // Actions
  // ...
  Future<void> onSetNewPasswordPressed() async {
    if (_formKey.currentState!.validate()) {
      try {
        dialog.showDialog(
          DialogRequest(
              type: DialogType.progressDialog, title: "Change in progress..."),
        );

        await _userService.changePassword(_newPasswordController.text);

        dialog.hideDialog();
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Password changed successfully!",
            type: ESnackbarType.success,
          ),
        );
        goBack();
      } on ErrorData catch (e) {
        dialog.hideDialog();

        errorHandler(snackbar, e: e);
      }
    }
  }
}
