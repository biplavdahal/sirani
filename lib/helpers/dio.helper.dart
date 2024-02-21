import 'dart:convert';

import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/views/dashboard/dashboard.model.dart';

ErrorData dioError(DioError e) {
  late Map<String, dynamic> data;

  if (e.response != null) {
    if ((e.response!.data as Map<String, dynamic>).containsKey('stack-trace')) {
      data = {
        "response": "Something unexpected occured from server side.",
      };
    } else {
      data = jsonDecode(e.response!.data);

      if (!data.containsKey("response")) {
        data.putIfAbsent("response", () => data["message"]);
      }
    }
  } else {
    debugPrint("e: ${e.response?.data}");
    data = {
      "response": "Could not talk to server at this time. Try again later!",
    };
  }

  return ErrorData.fromJson(data);
}

Map<String, dynamic>? constructResponse(dynamic data) {
  Map<String, dynamic>? constructedResponse;

  if (data is String) {
    constructedResponse = jsonDecode(data);
  } else if (data is Map) {
    constructedResponse = data as Map<String, dynamic>;
  }

  return constructedResponse;
}

void errorHandler(
  SnackbarService snackbar, {
  required ErrorData e,
}) {
  if (e.response == "Invalid Access Token") {
    locator<DashboardModel>().moreActions("logout");
    return;
  }

  snackbar.displaySnackbar(
    SnackbarRequest.of(
      message: e.response,
      type: ESnackbarType.error,
      duration: ESnackbarDuration.long,
    ),
  );
}
