import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/statement.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/wallet.service.dart';

class StatementModel extends ViewModel with SnackbarMixin {
  // Services
  final WalletService _walletService = locator<WalletService>();

  // UI Controrllers
  // ...

  // Data
  List<StatementData>? get statements => _walletService.statements;
  bool get hasMoreStatements => _walletService.hasMoreStatements;

  // Actions
  Future<void> init({
    bool forceRefresh = false,
  }) async {
    try {
      if (forceRefresh) {
        _walletService.reset();
      }

      setLoading();
      await _walletService.fetchStatements();
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }
}
