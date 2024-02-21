import 'dart:convert';

import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/constants/pref_keys.dart';
import 'package:mysirani/data_model/auth.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/data_model/user.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/notification.service.dart';
import 'package:mysirani/views/chats_list/chat_list.model.dart';
import 'package:mysirani/views/dashboard/fragments/appointments/appointments.model.dart';
import 'package:mysirani/views/dashboard/fragments/counsellors/counsellors.model.dart';
import 'package:mysirani/views/dashboard/fragments/home/home.model.dart';
import 'package:mysirani/views/dashboard/fragments/profile/profile.model.dart';
import 'package:mysirani/views/dashboard/fragments/resources/resources.model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysirani/views/free_sessions/free_sessions.model.dart';
import 'package:mysirani/views/manage_schedule/manage_schedule.model.dart';

class AuthenticationServiceImplementation implements AuthenticationService {
  // External dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    "email",
    "profile",
  ]);
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  // Services
  final ApiService _apiService = locator<ApiService>();
  final SharedPreferenceService _sharedPreferenceService =
      locator<SharedPreferenceService>();
  final NotificationService _notificationService =
      locator<NotificationService>();

  bool _isNormalUser = false;
  @override
  bool get isNormalUser => _isNormalUser;

  @override
  bool get isSocialUser => _auth == null
      ? false
      : _auth?.user.googleId != null || _auth?.user.facebookId != null;

  AuthData? _auth;
  @override
  AuthData? get auth => _auth;

  @override
  Future<void> signInWithUsernameAndPassword(
      String username, String password) async {
    try {
      final response = await _apiService.post(auSignIn, {}, params: {
        "username": username,
        "password": password,
      });

      debugPrint(response.data.toString());

      final data = constructResponse(response.data);

      if (!data!["status"]) {
        throw ErrorData.fromJson(data);
      }

      _auth = AuthData.fromJson(data);
      await _sharedPreferenceService.set<String>(
        spfLoggedInUser,
        jsonEncode(
          _auth!.toJson(),
        ),
      );

      await _notificationService.updateFcmToken(
        _auth!.accessToken,
        _auth!.userId,
      );

      _isNormalUser = _auth!.user.role == "userfrontend";
      debugPrint("Logged in with access token ${_auth!.accessToken}");
      debugPrint("User ID: ${_auth!.userId}");
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<String> requestResetPassword(String email) async {
    try {
      final response =
          await _apiService.post(auRequestResetPassword, {}, params: {
        "email": email,
      });

      final data = constructResponse(response.data);

      if (!data!["status"]) {
        throw ErrorData.fromJson(data);
      }

      return data["response"];
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<bool> isSignnedIn() async {
    final _pref = await _sharedPreferenceService.get<String?>(spfLoggedInUser);

    if (_pref.value == null) return false;

    _auth = AuthData.fromJson(jsonDecode(_pref.value!));
    _isNormalUser = _auth!.user.role == "userfrontend";

    final _response = await _apiService.get('user/profile', params: {
      "access_token": _auth!.accessToken,
    });

    if (_response.data is String) {
      _auth = null;
      _isNormalUser = false;
      return false;
    }

    _auth = _auth?.copyWith(balance: _response.data['balance']);

    debugPrint("Logged in with access token ${_auth!.accessToken}");
    debugPrint("User ID: ${_auth!.userId}");

    return true;
  }

  @override
  Future<void> signOut() async {
    try {
      await _apiService.post(auSignOut, {}, params: {
        "access_token": _auth!.accessToken,
      });

      await _sharedPreferenceService.remove(spfLoggedInUser);
      _auth = null;

      if (locator<HomeModel>().onModelReadyCalled) {
        locator<HomeModel>().setOnModelReadyCalled(status: false);
      }
      if (locator<CounsellorsModel>().onModelReadyCalled) {
        locator<CounsellorsModel>().setOnModelReadyCalled(status: false);
      }
      if (locator<AppointmentsModel>().onModelReadyCalled) {
        locator<AppointmentsModel>().setOnModelReadyCalled(status: false);
      }
      if (locator<ResoucesModel>().onModelReadyCalled) {
        locator<ResoucesModel>().setOnModelReadyCalled(status: false);
      }
      if (locator<ProfileModel>().onModelReadyCalled) {
        locator<ProfileModel>().setOnModelReadyCalled(status: false);
      }

      if (locator<ManageScheduleModel>().onModelReadyCalled) {
        locator<ManageScheduleModel>().setOnModelReadyCalled(status: false);
      }

      if (locator<FreeSessionsModel>().onModelReadyCalled) {
        locator<FreeSessionsModel>().setOnModelReadyCalled(status: false);
      }

      if (locator<ChatsListModel>().onModelReadyCalled) {
        locator<ChatsListModel>().setOnModelReadyCalled(status: false);
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint(e.response!.realUri.toString());
      debugPrint(e.response!.statusCode.toString());
      debugPrint(e.response!.statusMessage);
      debugPrint(e.toString());

      throw dioError(e);
    }
  }

  @override
  Future<List<String>?> signUp({
    required String fullName,
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    required String address,
  }) async {
    try {
      final response = await _apiService.post(auSignUp, {
        "full_name": fullName,
        "email": email,
        "password": password,
        "username": username,
        "mobile": phoneNumber,
        "address": address,
      });

      final data = constructResponse(response.data);

      if (!data!["status"]) {
        final errors = <String>[];

        final errorObj = data["data"] as Map<String, dynamic>;

        for (final err in errorObj.values.toList()) {
          errors.addAll([...err]);
        }

        return errors;
      }

      return null;
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<void> updateUser(Map<String, dynamic> data) async {
    _auth = _auth!.copyWith(
      user: UserData.fromJson(data),
    );

    await _sharedPreferenceService.set<String>(
      spfLoggedInUser,
      jsonEncode(
        _auth!.toJson(),
      ),
    );
    _isNormalUser = _auth!.user.role == "userfrontend";
  }

  @override
  Future<void> updateBalance([int? balance]) async {
    if (balance == null) {
      final _response = await _apiService.get('user/profile', params: {
        "access_token": _auth!.accessToken,
      });

      _auth = _auth?.copyWith(balance: int.parse(_response.data['balance']));
    } else {
      _auth = _auth!.copyWith(
        balance: _auth!.balance + balance,
      );
    }

    await _sharedPreferenceService.set<String>(
      spfLoggedInUser,
      jsonEncode(
        _auth!.toJson(),
      ),
    );
    _isNormalUser = _auth!.user.role == "userfrontend";
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final auth = await _googleSignIn.signIn();

      if (auth == null) {
        throw const ErrorData(response: "Sign In process cancelled.");
      }
      await _googleSignIn.signOut();
      await _continueWithSocialAuth(
        type: "google",
        email: auth.email,
        fullName: auth.displayName ?? "",
        username: auth.id,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signInWithFacebook() async {
    try {
      final auth = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      if (auth.status == LoginStatus.success) {
        final userData =
            await _facebookAuth.getUserData(fields: "name,email,id");
        await _continueWithSocialAuth(
          type: "facebook",
          email: userData["email"],
          fullName: userData["name"],
          username: userData["id"],
        );
        await _facebookAuth.logOut();
      } else {
        throw const ErrorData(response: "Sign In process cancelled.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _continueWithSocialAuth({
    required String type,
    required String email,
    required String fullName,
    required String username,
  }) async {
    try {
      final response = await _apiService.post(auSocialSignIn, {
        "username": username,
        "email": email,
      }, params: {
        "type": type,
        "email": email,
        "name": fullName,
        "id": username,
      });

      final data = constructResponse(response.data);

      if (!data!["status"]) {
        throw ErrorData.fromJson(data);
      }

      _auth = AuthData.fromJson(data);
      await _sharedPreferenceService.set<String>(
        spfLoggedInUser,
        jsonEncode(
          _auth!.toJson(),
        ),
      );

      await _notificationService.updateFcmToken(
        _auth!.accessToken,
        _auth!.userId,
      );

      _isNormalUser = _auth!.user.role == "userfrontend";
      debugPrint("Logged in with access token ${_auth!.accessToken}");
      debugPrint("User ID: ${_auth!.userId}");
    } on DioError catch (e) {
      throw dioError(e);
    }
  }
}
