import 'dart:io';

import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/user.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/helpers/file.helper.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.mixin.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/user.service.dart';

class EditProfileModel extends ViewModel
    with BottomSheetMixin, SnackbarMixin, DialogMixin {
  // Services
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final UserService _userService = locator<UserService>();

  // UI Components
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final TextEditingController _fullnameController = TextEditingController();
  TextEditingController get fullnameController => _fullnameController;
  final TextEditingController _mobileController = TextEditingController();
  TextEditingController get mobileController => _mobileController;
  final TextEditingController _addressController = TextEditingController();
  TextEditingController get addressController => _addressController;
  final TextEditingController _educationController = TextEditingController();
  TextEditingController get educationController => _educationController;
  final TextEditingController _skillsController = TextEditingController();
  TextEditingController get skillsController => _skillsController;
  final TextEditingController _experienceController = TextEditingController();
  TextEditingController get experienceController => _experienceController;
  final TextEditingController _languageController = TextEditingController();
  TextEditingController get languageController => _languageController;
  final TextEditingController _introductionController = TextEditingController();
  TextEditingController get introductionController => _introductionController;
  final TextEditingController _designationController = TextEditingController();
  TextEditingController get designationController => _designationController;

  // Data
  File? _newProfileImage;
  File? get newProfileImage => _newProfileImage;

  // Actions
  void init() {
    _fullnameController.text = _authenticationService.auth!.user.fullName!;
    _mobileController.text = _authenticationService.auth!.user.mobile ?? "";
    _addressController.text = _authenticationService.auth!.user.address ?? "";

    if (!_authenticationService.isNormalUser) {
      _educationController.text =
          _authenticationService.auth!.user.education ?? "";
      _skillsController.text = _authenticationService.auth!.user.skills ?? "";
      _experienceController.text =
          _authenticationService.auth!.user.experience ?? "";
      _languageController.text =
          _authenticationService.auth!.user.language ?? "";
      _introductionController.text =
          _authenticationService.auth!.user.summary ?? "";
      _designationController.text =
          _authenticationService.auth!.user.type ?? "";
    }

    setIdle();
  }

  Future<void> onChangeProfilePicturePressed() async {
    try {
      final source = await bottomSheet.showBottomSheet(
        BottomSheetRequest(
          type: BottomSheetType.mediaSource,
          title: "Choose image source...",
        ),
      );

      final _pickedFile = await ImagePicker().pickImage(
        source: source.result == "c" ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50,
      );

      if (_pickedFile != null) {
        _newProfileImage = File(_pickedFile.path);
        setIdle();
      }
    } catch (e) {
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: "Something went wrong!",
          type: ESnackbarType.error,
        ),
      );
    }
  }

  Future<void> onUpdatePressed() async {
    if (_formKey.currentState!.validate()) {
      try {
        final currentData = locator<AuthenticationService>().auth!.user;

        final currentDataJson = currentData
            .copyWith(
              fullName: _fullnameController.text,
              mobile: _mobileController.text,
              address: _addressController.text,
              education: _educationController.text,
              skills: _skillsController.text,
              experience: _experienceController.text,
              language: _languageController.text,
              summary: _introductionController.text,
              type: _designationController.text,
            )
            .toJson();

        dialog.showDialog(
          DialogRequest(type: DialogType.progressDialog, title: "Updating..."),
        );

        if (_newProfileImage == null) {
          currentDataJson.remove("image");
        } else {
          currentDataJson["image"] = FileHelper.getBase64(_newProfileImage!);
        }
        await _userService.updateProfile(UserData.fromJson(currentDataJson));

        dialog.hideDialog();
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Profile updated!",
            type: ESnackbarType.success,
          ),
        );
      } on ErrorData catch (e) {
        dialog.hideDialog();

        errorHandler(snackbar, e: e);
      }
      goBack();
    }
  }
}
