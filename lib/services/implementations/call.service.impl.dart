import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/call.service.dart';
import 'package:mysirani/services/heroku_api.service.dart';

class CallServiceImplementation implements CallService {
  final HerokuApiService _herokuApiService = locator<HerokuApiService>();
  final ApiService _apiService = locator<ApiService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  @override
  Future<String> getCallToken(String? channel) async {
    try {
      final response = await _herokuApiService.get(auCallToken, params: {
        'channel': channel ?? _authenticationService.auth!.username,
        'uid': 0
      });

      return response.data["token"];
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> sendCallNotification({
    required String callToken,
    required int userId,
  }) async {
    try {
      await _apiService.post(auSendCallNotification, {
        'token': callToken,
        'user_id': userId,
        'access_token': _authenticationService.auth!.accessToken,
        'channel': _authenticationService.auth!.username,
      });
    } on DioError catch (e) {
      throw dioError(e);
    }
  }
}
