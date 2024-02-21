
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';

abstract class BottomSheetService {
  void registerSheetListener(
      Function(BottomSheetRequest request) showSheetListener);

  Future<BottomSheetResponse> showBottomSheet(BottomSheetRequest sheetRequest);

  void hideBottomSheet([BottomSheetResponse response]);
}
