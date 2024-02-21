import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/views/authentication/data_model/top_bar.data.dart';
import 'package:mysirani/views/dashboard/dashboard.view.dart';

class AuthenticationModel extends ViewModel with SnackbarMixin, DialogMixin {
  // Services
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  // UI components
  late TabController _tabController;
  TabController get tabController => _tabController;

  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get signInFormKey => _signInFormKey;
  final GlobalKey<FormState> _signup1FormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get signup1FormKey => _signup1FormKey;
  final GlobalKey<FormState> _signup2FormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get signup2FormKey => _signup2FormKey;
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get forgotPasswordFormKey => _forgotPasswordFormKey;

  // - Login Form Controllers
  final TextEditingController _signInUsernameController =
      TextEditingController();
  TextEditingController get signInUsernameController =>
      _signInUsernameController;
  final TextEditingController _signInPasswordController =
      TextEditingController();
  TextEditingController get signInPasswordController =>
      _signInPasswordController;

  // - Sign Up 1 Form Controllers
  final TextEditingController _signup1FullNameController =
      TextEditingController();
  TextEditingController get signup1FullNameController =>
      _signup1FullNameController;
  final TextEditingController _signUp1EmailController = TextEditingController();
  TextEditingController get signUp1EmailController => _signUp1EmailController;
  final TextEditingController _signUp1PhoneNumberController =
      TextEditingController();
  TextEditingController get signUp1PhoneNumberController =>
      _signUp1PhoneNumberController;
  final TextEditingController _signUp1AddressController =
      TextEditingController();
  TextEditingController get signUp1AddressController =>
      _signUp1AddressController;

  // - Sing Up 2 Form Controllers
  final TextEditingController _signUp2UsernameController =
      TextEditingController();
  TextEditingController get signUp2UsernameController =>
      _signUp2UsernameController;
  final TextEditingController _signUp2PasswordController =
      TextEditingController();
  TextEditingController get signUp2PasswordController =>
      _signUp2PasswordController;
  final TextEditingController _signUp2ConfirmPasswordController =
      TextEditingController();
  TextEditingController get signUp2ConfirmPasswordController =>
      _signUp2ConfirmPasswordController;

  bool _signUp2TNC = false;
  bool get signUp2TNC => _signUp2TNC;
  set signUp2TNC(bool value) {
    _signUp2TNC = value;
    setIdle();
  }

  bool _signIn2TNC = false;
  bool get signIn2TNC => _signIn2TNC;
  set signIn2TNC(bool value) {
    _signIn2TNC = value;
    setIdle();
  }

  // - Forgot Password Form Controllers
  final TextEditingController _forgotPasswordEmailController =
      TextEditingController();
  TextEditingController get forgotPasswordEmailController =>
      _forgotPasswordEmailController;

  // Data
  TopBarData _topBarData = TopBarData(
    title: "Welcome Again",
    subtitle: "Sign in to continue",
    enableBack: false,
    activeSignUp: false,
    activeSignIn: true,
  );

  TopBarData get topBarData => _topBarData;

  late String _title;
  String get title => _title;
  late String _subtitle;
  String get subtitle => _subtitle;
  late bool _isActiveSignIn;
  bool get isActiveSignIn => _isActiveSignIn;
  late bool _isActiveSignUp;
  bool get isActiveSignUp => _isActiveSignUp;
  late bool _enableBack;
  bool get enableBack => _enableBack;

  // Action
  void init({
    required TickerProvider tickerProvider,
  }) {
    _tabController = TabController(
      length: 4,
      vsync: tickerProvider,
      initialIndex: 0,
    );

    setIdle();
  }

  void gotoTab(int index) {
    if (index == 0) {
      _topBarData = TopBarData(
        title: "Welcome Again",
        subtitle: "Sign in to continue",
        enableBack: false,
        activeSignUp: false,
        activeSignIn: true,
      );
    } else if (index == 1) {
      _topBarData = TopBarData(
        title: "Create Account",
        subtitle: "Step 1 of 2",
        enableBack: false,
        activeSignUp: true,
        activeSignIn: false,
      );
    } else if (index == 2) {
      _topBarData = TopBarData(
        title: "Create Account",
        subtitle: "Step 2 of 2",
        enableBack: true,
        activeSignUp: true,
        activeSignIn: false,
      );
    } else {
      _topBarData = TopBarData(
        title: "Reset Password",
        subtitle:
            "Please fill out your email. A link to reset password will be sent there.",
        enableBack: false,
        activeSignUp: false,
        activeSignIn: false,
      );
    }

    _tabController.animateTo(index);
    setIdle();
  }

  void onSignInPressed() {
    if (_signInFormKey.currentState!.validate()) {
      _singIn();
    }
  }

  Future<void> _singIn({
    bool bypassTnc = false,
  }) async {
    if (_signIn2TNC == false && bypassTnc == false) {
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: "You must agree terms and condition.",
          type: ESnackbarType.warning,
        ),
      );
      return;
    }

    dialog.showDialog(
      DialogRequest(
        type: DialogType.progressDialog,
        title: "Please wait... Authentication in progress..",
        dismissable: false,
      ),
    );

    try {
      await _authenticationService.signInWithUsernameAndPassword(
        _signInUsernameController.text.trim(),
        _signInPasswordController.text.trim(),
      );
      gotoAndClear(DashboardView.tag);
    } on ErrorData catch (e) {
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.response,
          type: ESnackbarType.error,
          duration: ESnackbarDuration.long,
        ),
      );
    }

    dialog.hideDialog();
  }

  void onSignUp1Pressed() {
    if (_signup1FormKey.currentState!.validate()) {
      gotoTab(2);
    }
  }

  Future<void> onSignUp2Pressed() async {
    if (_signup2FormKey.currentState!.validate()) {
      if (_signUp2TNC) {
        try {
          setAlert(viewState: EState.error, message: "");
          setIdle();
          dialog.showDialog(
            DialogRequest(
              type: DialogType.progressDialog,
              title: "Please wait... Registration in progress..",
              dismissable: false,
            ),
          );

          final response = await _authenticationService.signUp(
            fullName: _signup1FullNameController.text.trim(),
            email: _signUp1EmailController.text.trim(),
            password: _signUp2PasswordController.text,
            username: _signUp2UsernameController.text.trim(),
            phoneNumber: _signUp1PhoneNumberController.text.trim(),
            address: _signUp1AddressController.text.trim(),
          );

          if (response == null) {
            // Authenticate user
            _signInUsernameController.text = _signUp2UsernameController.text;
            _signInPasswordController.text = _signUp2PasswordController.text;

            await _singIn(
              bypassTnc: true,
            );
          } else {
            setAlert(viewState: EState.error, message: response.join("\n"));
          }
        } on ErrorData catch (e) {
          snackbar.displaySnackbar(
            SnackbarRequest.of(
              message: e.response,
              type: ESnackbarType.error,
              duration: ESnackbarDuration.long,
            ),
          );
        }
        dialog.hideDialog();
      } else {
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "You must agree terms and condition.",
            type: ESnackbarType.warning,
          ),
        );
      }
    }
  }

  Future<void> onForgotPasswordPressed() async {
    if (_forgotPasswordFormKey.currentState!.validate()) {
      dialog.showDialog(
        DialogRequest(
          type: DialogType.progressDialog,
          title: "Please wait... Processing your request...",
          dismissable: false,
        ),
      );
      try {
        final response = await _authenticationService
            .requestResetPassword(_forgotPasswordEmailController.text.trim());
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: response,
            type: ESnackbarType.success,
            duration: ESnackbarDuration.long,
          ),
        );
        gotoTab(0);
      } on ErrorData catch (e) {
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: e.response,
            type: ESnackbarType.error,
          ),
        );
      }

      dialog.hideDialog();
    }
  }

  Future<void> continueWithGoogle() async {
    try {
      dialog.showDialog(
        DialogRequest(
          type: DialogType.progressDialog,
          title: "Please wait... Authentication in progress..",
          dismissable: false,
        ),
      );
      await _authenticationService.signInWithGoogle();
      dialog.hideDialog();
      gotoAndClear(DashboardView.tag);
    } on ErrorData catch (e) {
      dialog.hideDialog();
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.response,
          type: ESnackbarType.error,
          duration: ESnackbarDuration.long,
        ),
      );
    } catch (e) {
      dialog.hideDialog();
      SnackbarRequest.of(
        message: e.toString(),
        type: ESnackbarType.error,
        duration: ESnackbarDuration.long,
      );
    }
  }

  Future<void> continueWithFacebook() async {
    try {
      dialog.showDialog(
        DialogRequest(
          type: DialogType.progressDialog,
          title: "Please wait... Authentication in progress..",
          dismissable: false,
        ),
      );
      await _authenticationService.signInWithFacebook();
      dialog.hideDialog();
      gotoAndClear(DashboardView.tag);
    } on ErrorData catch (e) {
      dialog.hideDialog();
      SnackbarRequest.of(
        message: e.toString(),
        type: ESnackbarType.error,
        duration: ESnackbarDuration.long,
      );
    }
  }
}
