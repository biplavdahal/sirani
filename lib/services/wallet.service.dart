import 'package:mysirani/data_model/statement.data.dart';

abstract class WalletService {
  /// Getter for all wallet statememt
  List<StatementData>? get statements;

  /// This will return true if there is more statment data to fetch
  bool get hasMoreStatements;

  /// This method will refresh the service data
  void reset();

  /// Fetch all statements from the server
  Future<void> fetchStatements();

  /// Load balance
  Future<void> loadBalance(int amount, {
    required String source,
  });
}
