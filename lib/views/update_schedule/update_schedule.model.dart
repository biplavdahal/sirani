import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/mixins/snack_bar.mixin.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/counsellor_schedule.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/date.helper.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/counsellor.service.dart';
import 'package:mysirani/views/update_schedule/update_schedule.argument.dart';

class UpdateScheduleModel extends ViewModel with DialogMixin, SnackbarMixin {
  // Services
  final CounsellorService _counsellorService = locator<CounsellorService>();

  // UI components
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final TextEditingController _weekdayController = TextEditingController();
  TextEditingController get weekdayController => _weekdayController;

  final TextEditingController _fromTimeController = TextEditingController();
  TextEditingController get fromTimeController => _fromTimeController;

  final TextEditingController _toTimeController = TextEditingController();
  TextEditingController get toTimeController => _toTimeController;

  // Data
  CounsellorScheduleData? _schedule;

  bool get isEdit => _schedule != null;

  late bool _selectedStatus;
  bool get selectedStatus => _selectedStatus;

  void setSelectedStatus(bool value) {
    _selectedStatus = value;
    setIdle();
  }

  // Action
  void init(UpdateScheduleArgument argument) {
    _schedule = argument.schedule;
    setIdle();

    if (isEdit) {
      _weekdayController.text = _schedule!.day;
      _fromTimeController.text = _schedule!.fromTime;
      _toTimeController.text = _schedule!.toTime;
      _selectedStatus = _schedule!.status == "Active";
    }

    setIdle();
  }

  Future<void> onWeekdayPressed() async {
    final res = await dialog.showDialog(
      DialogRequest(
        type: DialogType.selection,
        title: "Select type",
        payload: [
          "Sunday",
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday"
        ],
      ),
    );

    _weekdayController.text = res!.result;

    setIdle();
  }

  Future<void> onFromTimePressed(BuildContext context) async {
    final _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      confirmText: 'SET',
      helpText:
          "Every session can be only 1 hour long and the minutes set will be ignored.",
    );

    if (_selectedTime != null) {
      _fromTimeController.text =
          _selectedTime.replacing(minute: 0).format(context);
      _toTimeController.text = _selectedTime
          .replacing(
            hour: _selectedTime.hour + 1,
            minute: 0,
          )
          .format(context);
      setIdle();
    }
  }

  Future<void> onAddPressed() async {
    if (_formKey.currentState!.validate()) {
      try {
        dialog.showDialog(
          DialogRequest(
            type: DialogType.progressDialog,
            title: "Adding time to slot...",
          ),
        );

        await _counsellorService.addSchedule(
          weekday: _weekdayController.text,
          fromTime: convert12To24Format(_fromTimeController.text),
          toTime: convert12To24Format(_toTimeController.text),
        );

        dialog.hideDialog();
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Time slot added!",
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

  Future<void> onUpdatePressed() async {
    if (_formKey.currentState!.validate()) {
      try {
        dialog.showDialog(
          DialogRequest(
            type: DialogType.progressDialog,
            title: "Updating time to slot...",
          ),
        );

        await _counsellorService.updateSchedule(
          weekday: _weekdayController.text,
          fromTime: convert12To24Format(_fromTimeController.text),
          toTime: convert12To24Format(_toTimeController.text),
          id: _schedule!.id,
          status: _selectedStatus ? "Active" : "Inactive",
        );

        dialog.hideDialog();
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Time slot added!",
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
