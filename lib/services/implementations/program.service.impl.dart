import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/program.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/program.service.dart';

class ProgramServiceImplementation implements ProgramService {
  // Services
  final ApiService _apiService = locator<ApiService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  bool _hasMore = true;
  @override
  bool get hasMore => _hasMore;

  final List<ProgramData> _programs = [];
  @override
  List<ProgramData> get programs => _programs;

  final int maxLimit = 4;
  int _currentPage = 0;

  @override
  Future<void> fetchPrograms() async {
    if (_hasMore) {
      try {
        _currentPage++;

        final response = await _apiService.get(auPrograms, params: {
          'access_token': _authenticationService.auth!.accessToken,
          'page': _currentPage,
          'limit': maxLimit,
        });

        final data = constructResponse(response.data);

        if (data!["status"] == "failure") {
          throw ErrorData.fromJson(data);
        }

        final programsJson = data["data"] as List;

        for (final programJson in programsJson) {
          _programs.add(ProgramData.fromJson(programJson));
        }

        _hasMore = maxLimit * _currentPage < data["count"];
      } on DioError catch (e) {
        throw dioError(e);
      }
    }
  }
}
