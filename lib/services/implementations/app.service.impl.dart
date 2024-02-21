import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/app.service.dart';
import 'package:mysirani/services/authentication.service.dart';

class AppServiceImplementation implements AppService {
  // Services
  final ApiService _apiService = locator<ApiService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  @override
  Future<String> getContent(String slug) async {
    try {
      final response = await _apiService.get(auPage, params: {
        "access_token": _authenticationService.auth!.accessToken,
        "slug": slug
      });

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }

      return data["data"][0]["post_content"];
    } on DioError catch (e) {
      throw dioError(e);
    }
  }
}
