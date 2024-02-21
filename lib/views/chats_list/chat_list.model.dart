import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/user.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/counsellor.service.dart';

class ChatsListModel extends ViewModel with SnackbarMixin {
  // Services
  final CounsellorService _counsellorService = locator<CounsellorService>();

  // Data
  List<UserData> get freeSessionThreads => _counsellorService.chats;

  // Actions
  Future<void> init() async {
    try {
      setLoading();
      await _counsellorService.fetchChatsList();

      if (_counsellorService.chats.isEmpty) {
        SnackbarRequest.of(
          message: "No sessions available!",
          type: ESnackbarType.warning,
          duration: ESnackbarDuration.long,
        );
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }
}
