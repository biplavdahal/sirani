import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/statement.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/notification.service.dart';
import 'package:mysirani/services/wallet.service.dart';

class WalletServiceImplementation implements WalletService {
  // Services
  final ApiService _apiService = locator<ApiService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NotificationService _notificationService =
      locator<NotificationService>();

  List<StatementData>? _statements;
  @override
  List<StatementData>? get statements => _statements;

  bool _hasMoreStatements = true;
  @override
  bool get hasMoreStatements => _hasMoreStatements;

  late int _currentPage = 0;
  final int _statementsPerPage = 12;

  @override
  void reset() {
    _hasMoreStatements = true;
    _currentPage = 0;
    _statements = null;
  }

  @override
  Future<void> fetchStatements() async {
    try {
      if (_hasMoreStatements) {
        _currentPage++;
        final response = await _apiService.get(auGetStatement, params: {
          "access_token": _authenticationService.auth!.accessToken,
          "page": _currentPage,
          "limit": _statementsPerPage,
        });

        final data = constructResponse(response.data);

        if (data!["status"] == "failure") {
          throw ErrorData.fromJson(data);
        }

        if (data['data'] is String) {
          throw const ErrorData(
            response: "There is nothing in statement to show",
          );
        }

        final _statmentsJson = data["data"] as List;

        _statements ??= [];

        for (final statementJson in _statmentsJson) {
          _statements!.add(StatementData.fromJson(statementJson));
        }

        final int totalStatements = data["count"] as int;
        if (totalStatements > _currentPage * _statementsPerPage) {
          _hasMoreStatements = true;
        } else {
          _hasMoreStatements = false;
        }
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> loadBalance(int amount, {required String source}) async {
    try {
      final response = await _apiService.post(auLoadBalance, {
        "access_token": _authenticationService.auth!.accessToken,
        "amount": amount.toString(),
        "source": source,
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      await _authenticationService.updateBalance(amount);
      await _notificationService.showNotification(
        title: "Fund loaded!",
        body: "Rs.$amount has been loaded to your wallet from $source.",
      );
    } on DioError catch (e) {
      throw dioError(e);
    }
  }
}
