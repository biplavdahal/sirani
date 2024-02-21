import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/mixins/snack_bar.mixin.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/program.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/program.service.dart';

class ProgramsModel extends ViewModel with SnackbarMixin {
  // Services
  final ProgramService _programService = locator<ProgramService>();

  // UI components
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  // Data
  List<ProgramData> get programs => _programService.programs;
  bool get hasMore => _programService.hasMore;

  // Actions
  Future<void> init() async {
    try {
      setLoading();
      await _programService.fetchPrograms();

      if (!_scrollController.hasListeners) {
        _scrollController.addListener(() async {
          if (_scrollController.position.atEdge) {
            if (_scrollController.position.pixels != 0) {
              await _programService.fetchPrograms();
              setIdle();
            }
          }
        });
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }
}
