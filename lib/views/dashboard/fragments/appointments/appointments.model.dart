import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/appointment.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/session_time.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/services/call.service.dart';
import 'package:mysirani/views/appointment_detail/appointment_detail.argument.dart';
import 'package:mysirani/views/appointment_detail/appointment_detail.view.dart';

class AppointmentsModel extends ViewModel with SnackbarMixin, DialogMixin {
  // Services
  final AppointmentService _appointmentService = locator<AppointmentService>();
  final CallService _callService = locator<CallService>();

  // Data
  List<AppointmentData> get appointments => _appointmentService.appointments;

  // Actions
  Future<void> init() async {
    try {
      setLoading();
      await _appointmentService.fetchAppointments();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
    setIdle();
  }

  Future<void> approveAppoitnmentPressed(AppointmentData appointment) async {
    try {
      dialog.showDialog(
        DialogRequest(type: DialogType.progressDialog, title: "Approving..."),
      );

      await _appointmentService.approveOrDeclineAppointment(
        appointment.info.appointmentId,
      );

      _appointmentService.updateAppointment(
        appointment.copyWith(
          info: appointment.info.copyWith(
            status: "Approved",
          ),
        ),
      );
      dialog.hideDialog();
      setIdle();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }

  Future<void> declineAppoitnmentPressed(AppointmentData appointment) async {
    try {
      dialog.showDialog(
        DialogRequest(type: DialogType.progressDialog, title: "Declining..."),
      );

      await _appointmentService.approveOrDeclineAppointment(
        appointment.info.appointmentId,
        isApproved: false,
      );

      _appointmentService.updateAppointment(
        appointment.copyWith(
          info: appointment.info.copyWith(
            status: "Declined",
          ),
        ),
      );
      dialog.hideDialog();
      setIdle();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }

  void viewDetail(AppointmentData appointment) async {
    goto(
      AppointmentDetailView.tag,
      arguments: AppointmentDetailArgument(appointment),
    );
  }

  Future<String?> joinVideoCall(AppointmentData appointment) async {
    try {
      dialog.showDialog(
        DialogRequest(
            type: DialogType.progressDialog, title: "Creating session..."),
      );

      final callToken = await _callService.getCallToken(null);

      debugPrint(callToken);

      dialog.hideDialog();
      setIdle();

      return callToken;
    } on ErrorData catch (e) {
      dialog.hideDialog();
      errorHandler(snackbar, e: e);
    }
  }

  Future<void> sendCallNotification(
      String callToken, AppointmentData appointment) async {
    try {
      dialog.showDialog(
        DialogRequest(type: DialogType.progressDialog, title: "Joining..."),
      );

      await _callService.sendCallNotification(
        callToken: callToken,
        userId: appointment.secondParty.id,
      );

      dialog.hideDialog();
    } on ErrorData catch (e) {
      dialog.hideDialog();
      errorHandler(snackbar, e: e);
    }
  }

  Future<SessionTimeData?> remainingDuration(
      AppointmentData appointment) async {
    try {
      final duration = await _appointmentService
          .getSessionRemainigDuration(appointment.secondParty.id);

      return duration;
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }
}
