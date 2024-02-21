import 'dart:io';

import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/survey_question.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/helpers/file.helper.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.mixin.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/create_appointment/create_appointment.view.dart';
import 'package:mysirani/views/survey/survey_document.view.dart';

class SurveyModel extends ViewModel
    with SnackbarMixin, BottomSheetMixin, DialogMixin {
  // Services
  final AppointmentService _appointmentService = locator<AppointmentService>();

  // Data
  late List<SurveyQuestionData> _surveyQuestions;
  List<SurveyQuestionData> get surveyQuestions => _surveyQuestions;

  final List<Map<String, dynamic>> _answers = [];
  List<Map<String, dynamic>> get answers => _answers;

  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;

  File? _document;
  File? get document => _document;

  // Action
  Future<void> init() async {
    try {
      setLoading();

      _surveyQuestions = await _appointmentService.getSurveyQuestions();

      if (_surveyQuestions.isEmpty) {
        if (await _appointmentService.surveyHasAttachement()) {
          gotoAndPop(CreateAppointmentView.tag);
        } else {
          gotoAndPop(SurveyDocumentView.tag);
        }
      } else {
        setIdle();
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
      goBack();
    }
  }

  Future<void> onDocumentAddPressed() async {
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
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: _pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioY: 3, ratioX: 5),
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio5x3,
          ],
          androidUiSettings: const AndroidUiSettings(
            toolbarTitle: "Crop Document",
            toolbarColor: AppColor.primary,
            initAspectRatio: CropAspectRatioPreset.ratio5x3,
            statusBarColor: AppColor.primary,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppColor.accent,
          ),
          iosUiSettings: const IOSUiSettings(
            title: "Crop Document",
            hidesNavigationBar: true,
            minimumAspectRatio: 5.3,
          ),
        );

        if (croppedImage != null) {
          _document = croppedImage;
        }

        setIdle();
      }
    } catch (e) {
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: "Something went wrong while picking document!",
          type: ESnackbarType.error,
        ),
      );
    }
  }

  Future<void> onUploadDocumentPressed() async {
    if (_document == null) {
      snackbar.displaySnackbar(SnackbarRequest.of(
        message: "You must select an image before you proceed.",
        type: ESnackbarType.warning,
      ));

      return;
    }

    try {
      dialog.showDialog(
        DialogRequest(
            type: DialogType.progressDialog, title: "Uploading document..."),
      );
      await _appointmentService.uploadSurveyDocument(
        FileHelper.getBase64(_document!),
      );
      dialog.hideDialog();
      goBack();
    } on ErrorData catch (e) {
      dialog.hideDialog();

      errorHandler(snackbar, e: e);
    }
  }

  int? getGroupValueAnswer() {
    try {
      if (_answers.isEmpty) {
        return null;
      }
      final Map<String, dynamic>? answer = answers.firstWhere(
        (_answer) =>
            _answer["question_id"] ==
            _surveyQuestions[_currentQuestionIndex].id,
        orElse: () => {},
      );

      return answer == null ? null : answer["user_answer"];
    } catch (_) {
      return null;
    }
  }

  void setAnswer({
    required int answerId,
  }) {
    if (_answers.isEmpty) {
      _answers.add({
        "question_id": _surveyQuestions[_currentQuestionIndex].id,
        "user_answer": answerId,
        "question_title": _surveyQuestions[_currentQuestionIndex].question,
      });
      setIdle();
    } else {
      final Map<String, dynamic>? _answer = answers.firstWhere(
        (e) => e["question_id"] == _surveyQuestions[_currentQuestionIndex].id,
        orElse: () => {},
      );

      if (_answer!.isEmpty) {
        _answers.add({
          "question_id": _surveyQuestions[_currentQuestionIndex].id,
          "user_answer": answerId,
          "question_title": _surveyQuestions[_currentQuestionIndex].question,
        });
      } else {
        final index = answers.indexOf(_answer);
        _answers[index]["user_answer"] = answerId;
      }
      setIdle();
    }
  }

  void onNextPressed() {
    if (_currentQuestionIndex == _surveyQuestions.length - 1) {
      _onSubmitPressed();
    } else {
      _currentQuestionIndex++;
      setIdle();
    }
  }

  void onPreviousPressed() {
    _currentQuestionIndex--;
    setIdle();
  }

  Future<void> _onSubmitPressed() async {
    try {
      dialog.showDialog(
        DialogRequest(
          type: DialogType.progressDialog,
          title: "Submitting survey...",
        ),
      );
      await _appointmentService.postSurveyAnswers(_answers);
      dialog.hideDialog();
      gotoAndPop(SurveyDocumentView.tag);
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }
}
