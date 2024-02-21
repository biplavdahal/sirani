import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:esewa_pnp/esewa.dart';
import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/counsellor_schedule.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/date.helper.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/helpers/schedule_formatter.helper.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/counsellor.service.dart';
import 'package:mysirani/services/wallet.service.dart';

class CreateAppointmentModel extends ViewModel with SnackbarMixin, DialogMixin {
  // Service
  final CounsellorService _counsellorService = locator<CounsellorService>();
  final AppointmentService _appointmentService = locator<AppointmentService>();
  final WalletService _walletService = locator<WalletService>();

  // UI controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  final TextEditingController _typeController = TextEditingController();
  TextEditingController get typeController => _typeController;
  final TextEditingController _dateController = TextEditingController();
  TextEditingController get dateController => _dateController;
  final TextEditingController _detailController = TextEditingController();
  TextEditingController get detailController => _detailController;

  late Set<String> _availableTimes = {};
  Set<String> get availableTimes => _availableTimes;

  late String _selectedTime = "";
  String get selectedTime => _selectedTime;
  set selectedTime(String value) {
    _selectedTime = value;
    setIdle();
  }

  // Data
  late Map<String, List<CounsellorScheduleData>> _counsellorSchedules;
  Map<String, List<CounsellorScheduleData>> get counsellorSchedules =>
      _counsellorSchedules;

  final List<String> _services = [];
  List<String> get services => _services;

  late int _counsellorRate;
  int get counsellorRate => _counsellorRate;

  // Action
  Future<void> init() async {
    try {
      setLoading();

      final counsellor = await _counsellorService.fetchCounsellorProfile(
        _appointmentService.counsellorIdToBeBooking,
      );

      _counsellorSchedules = formatSchedule(counsellor.schedules);
      if (counsellor.profile.videoDisplay == 1) {
        _services.add('Video Call');
      }

      if (counsellor.profile.chatDisplay == 1) {
        _services.add('Chat');
      }

      _counsellorRate = counsellor.rate ?? 0;

      setIdle();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);

      goBack();
    }
  }

  Future<void> onAppointmentTypePressed() async {
    if (services.isEmpty) {
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: "Counsellor does not provide any services yet.",
          type: ESnackbarType.info,
        ),
      );
      return;
    }

    final res = await dialog.showDialog(
      DialogRequest(
        type: DialogType.selection,
        title: "Select type",
        payload: services,
      ),
    );

    _typeController.text = res!.result;

    setIdle();
  }

  Future<void> onAppointmentDatePressed(BuildContext context) async {
    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (_pickedDate != null) {
      _availableTimes.clear();
      _selectedTime = "";
      final schedule = _counsellorSchedules[weekday(_pickedDate.weekday)];
      if (schedule != null) {
        _availableTimes = schedule
            .where((e) {
              if (e.status != "Active") {
                return false;
              }

              if ("${_pickedDate.year}-${_pickedDate.month}-${_pickedDate.day}" ==
                  "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}") {
                final eHour = int.parse(
                  convert12To24Format("${e.fromTime} - ${e.toTime}")
                      .split(":")
                      .first,
                );
                return eHour > DateTime.now().hour;
              } else {
                return true;
              }
            })
            .map((e) => "${e.fromTime} - ${e.toTime}")
            .toSet();
      }

      _dateController.text =
          "${_pickedDate.year}-${_pickedDate.month}-${_pickedDate.day}";
    }

    setIdle();
  }

  Future<void> onAddAppointmentPressed() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTime.isEmpty) {
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "You must select a time.",
            type: ESnackbarType.warning,
          ),
        );
        return;
      }

      try {
        dialog.showDialog(
          DialogRequest(
              type: DialogType.progressDialog, title: "Please wait..."),
        );

        await _appointmentService.bookAppointment(
          counsellorId: _appointmentService.counsellorIdToBeBooking,
          time: convert12To24Format(_selectedTime),
          date: dateController.text,
          type: typeController.text,
          detail: detailController.text,
        );

        dialog.hideDialog();
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Appointment Booked!",
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

  Future<void> loadFund() async {
    try {
      ESewaPayment _payment = ESewaPayment(
        amount: double.parse(
            (_counsellorRate - locator<AuthenticationService>().auth!.balance)
                .toString()),
        productName: "Load Fund",
        productID: "load_fund",
        callBackURL: "https://app.mysirani.com/",
      );

      final result = await locator<ESewaPnp>().initPayment(payment: _payment);

      if (result is ESewaResult) {
        dialog.showDialog(
          DialogRequest(
              type: DialogType.progressDialog, title: "Loading fund..."),
        );
        await _walletService.loadBalance(
          int.parse(double.parse(result.totalAmount!).toStringAsFixed(0)),
          source: "Esewa",
        );
        dialog.hideDialog();

        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: "Rs.$_counsellorRate loaded into your My Sirani Balance.",
            type: ESnackbarType.success,
            duration: ESnackbarDuration.long,
          ),
        );
        setIdle();
      }
    } on ErrorData catch (e) {
      dialog.hideDialog();

      errorHandler(snackbar, e: e);
    } on ESewaPaymentException catch (e) {
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.message!,
          type: ESnackbarType.error,
        ),
      );
    }
  }
}
