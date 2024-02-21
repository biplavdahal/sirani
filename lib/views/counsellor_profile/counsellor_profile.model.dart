import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/counsellor.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.mixin.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/counsellor.service.dart';
import 'package:mysirani/views/counsellor_profile/counsellor_profile.argument.dart';
import 'package:mysirani/views/survey/survey.view.dart';

class CounsellorProfileModel extends ViewModel
    with SnackbarMixin, BottomSheetMixin, DialogMixin {
  // Service
  final CounsellorService _counsellorService = locator<CounsellorService>();
  final AppointmentService _appointmentService = locator<AppointmentService>();

  // UI Controllers
  late TabController _tabController;
  TabController get tabController => _tabController;

  // Data
  // ...
  late CounsellorData _counsellor;
  CounsellorData get counsellor => _counsellor;

  bool _isSelf = true;
  bool get isSelf => _isSelf;

  // Action
  Future<void> init(
    CounsellorProfileArgument argument, {
    required TickerProvider vsync,
  }) async {
    if (argument.counsellor != null) {
      _counsellor = argument.counsellor!;
      _isSelf = false;
    } else {
      _counsellor = CounsellorData(
        profile: locator<AuthenticationService>().auth!.user,
        rating: 0,
        totalSession: "0",
        status: "1",
      );
    }

    _tabController = TabController(length: 3, vsync: vsync);
    setIdle();

    try {
      setLoading();

      final _data = await _counsellorService.fetchCounsellorProfile(
        _counsellor.profile.id,
      );

      _counsellor = _counsellor.copyWith(
        rating: _data.rating,
        reviews: _data.reviews,
        schedules: _data.schedules,
      );
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }

  Future<void> onLikePressed() async {
    try {
      setWidgetBusy("like");

      await _counsellorService.addLike(
        _counsellor.profile.id,
        role: _counsellor.profile.role,
      );

      _counsellor = _counsellor.copyWith(
        hasLiked: "Yes",
      );

      // _counsellor.likes.add({});
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    unsetWidgetBusy("like");
  }

  void refreshProfile() {
    _counsellor = _counsellor.copyWith(
      profile: locator<AuthenticationService>().auth!.user,
    );
    setIdle();
  }

  Future<void> onRateCounsellorPressed() async {
    try {
      final _reviewController = TextEditingController();
      final _formKey = GlobalKey<FormState>();
      final bottomSheetResponse = await bottomSheet.showBottomSheet(
        BottomSheetRequest<List<BottomSheetFormPayload>>(
          type: BottomSheetType.form,
          title: "Post your review",
          addRatingBar: true,
          formKey: _formKey,
          payload: [
            BottomSheetFormPayload(
              controller: _reviewController,
              hintText: "Write review...",
              validator: FieldValidator.isRequired,
            ),
          ],
        ),
      );

      dialog.showDialog(
        DialogRequest(
          type: DialogType.progressDialog,
          title: "Posting your review...",
        ),
      );

      final review = await _counsellorService.addReview(
        _counsellor.profile.id,
        review: _reviewController.text.trim(),
        rating: bottomSheetResponse.result,
      );

      _counsellor.reviews!.add(review);

      dialog.hideDialog();

      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: "Review Posted",
          type: ESnackbarType.success,
        ),
      );
    } on ErrorData catch (e) {
      dialog.hideDialog();

      errorHandler(snackbar, e: e);
    }
    setIdle();
  }

  void onBookAnAppointmentPressed() {
    _appointmentService.setCounsellorIdToBeBooking(counsellor.profile.id);
    goto(SurveyView.tag);
  }
}
