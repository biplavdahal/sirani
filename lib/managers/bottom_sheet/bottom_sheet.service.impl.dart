import 'dart:async';

import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.service.dart';


class BottomSheetServiceImplementation implements BottomSheetService {
  late Function(BottomSheetRequest request) _showSheetListener;
  late Completer<BottomSheetResponse>? _sheetCompleter;

  @override
  void registerSheetListener(
      Function(BottomSheetRequest request) showSheetListener) {
    _showSheetListener = showSheetListener;
  }

  @override
  Future<BottomSheetResponse> showBottomSheet(BottomSheetRequest sheetRequest) {
    _sheetCompleter = Completer();
    _showSheetListener(sheetRequest);
    return _sheetCompleter!.future;
  }

  @override
  void hideBottomSheet([BottomSheetResponse? response]) {
    _sheetCompleter!.complete(response);
    _sheetCompleter = null;
  }
}
