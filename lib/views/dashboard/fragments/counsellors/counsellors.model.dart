import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/data_model/counsellor.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/services/counsellor.service.dart';
import 'package:mysirani/views/counsellor_profile/counsellor_profile.argument.dart';
import 'package:mysirani/views/counsellor_profile/counsellor_profile.view.dart';
import 'package:mysirani/views/dashboard/dashboard.model.dart';
import 'package:mysirani/views/survey/survey.view.dart';

class CounsellorsModel extends ViewModel with SnackbarMixin {
  // Services
  final CounsellorService _counsellorService = locator<CounsellorService>();
  final AppointmentService _appointmentService = locator<AppointmentService>();

  // UI Controllers
  List<CounsellorData>? get counsellors =>
      _counsellorService.counsellors[_selectedType];

  // Data Models
  List<String> get typeResponse =>
      ["counselor", "buddies", "volunteer_counselor"];
  List<String> get types => ["Counsellors", "Buddies", "Volunteers"];
  String _selectedType = "counselor";
  String get selectedType => _selectedType;
  void onSelectedType(String value) async {
    _selectedType = value;

    try {
      setAlert(viewState: EState.error, message: "");

      setWidgetBusy("loading-counselor");

      await _counsellorService.fetchRoles(_selectedType);
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setWidgetBusy("loading-counselor");
  }

  // Actions
  // ...
  Future<void> init() async {
    try {
      setAlert(viewState: EState.error, message: "");

      setLoading();

      await _counsellorService.fetchRoles(_selectedType);

      setIdle();
    } on ErrorData catch (e) {
      if (e.response == "Invalid Access Token") {
        locator<DashboardModel>().moreActions("logout");
        return;
      }
      setAlert(viewState: EState.error, message: e.response);
    }
  }

  Future<void> onCounsellorProfileTap(CounsellorData counsellor) async {
    await goto(
      CounsellorProfileView.tag,
      arguments: CounsellorProfileArgument(counsellor),
    );

    setIdle();
  }

  void onBookAnAppointmentPressed(CounsellorData counsellor) {
    _appointmentService.setCounsellorIdToBeBooking(counsellor.profile.id);
    goto(SurveyView.tag);
  }
}
