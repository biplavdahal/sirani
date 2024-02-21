import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:mysirani/data_model/counsellor_schedule.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/helpers/schedule_formatter.helper.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.mixin.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/counsellor.service.dart';

class ManageScheduleModel extends ViewModel
    with SnackbarMixin, BottomSheetMixin, DialogMixin {
  // Services
  final CounsellorService _counsellorService = locator<CounsellorService>();

  // Data
  Map<String, List<CounsellorScheduleData>> get schedules =>
      formatSchedule(_counsellorService.counsellorSchedules ?? []);

  // Action
  Future<void> init() async {
    try {
      setLoading();
      if (_counsellorService.counsellorSchedules == null) {
        await _counsellorService.fetchCounsellorSchedule();
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }

  Future<void> onDeletePressed(CounsellorScheduleData schedule) async {
    try {
      final sheetResponse = await bottomSheet.showBottomSheet(
        BottomSheetRequest(
          type: BottomSheetType.confirmation,
          title: 'Confirmation',
          description:
              'Are you sure you want to delete schedule for ${schedule.day} (${schedule.fromTime} - ${schedule.toTime})',
          dismissable: false,
          positiveButtonLabel: "Delete",
        ),
      );

      if (sheetResponse.result == true) {
        dialog.showDialog(
          DialogRequest(
              type: DialogType.progressDialog, title: "Removing schedule.."),
        );

        await _counsellorService.removeSchedule(schedule.id);

        dialog.hideDialog();

        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message:
                "Schedule for ${schedule.day} (${schedule.fromTime} - ${schedule.toTime}) has been removed!",
            type: ESnackbarType.success,
            duration: ESnackbarDuration.long,
          ),
        );
        setIdle();
      }
    } on ErrorData catch (e) {
      dialog.hideDialog();
      errorHandler(snackbar, e: e);
    }
  }
}
