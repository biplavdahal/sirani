import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/chat_plan.data.dart';

enum BottomSheetType {
  form,
  info,
  confirmation,
  chatPlanPayment,
  mediaSource,
}

class ChatPlanPayload {
  final int planRate;
  final ChatPlanData plan;
  final ValueSetter<ESewaResult> onESewaSuccess;
  final ValueSetter<ESewaPaymentException> onEsewaError;

  ChatPlanPayload({
    required this.planRate,
    required this.plan,
    required this.onESewaSuccess,
    required this.onEsewaError,
  });
}

class BottomSheetRequest<T> {
  final BottomSheetType type;
  final bool dismissable;
  final String title;
  final String? description;
  final T? payload;
  final String positiveButtonLabel;
  final String negativeButtonLabel;
  final bool showPositiveButtonLabel;
  final GlobalKey<FormState>? formKey;
  final bool addRatingBar;

  BottomSheetRequest({
    required this.type,
    required this.title,
    this.dismissable = true,
    this.description,
    this.payload,
    this.positiveButtonLabel = "Continue",
    this.negativeButtonLabel = "Cancel",
    this.showPositiveButtonLabel = true,
    this.formKey,
    this.addRatingBar = false,
  });
}

class BottomSheetResponse<T> {
  final T? result;

  BottomSheetResponse({this.result});
}

class BottomSheetFormPayload {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType inputType;
  final String? Function(String? value)? validator;

  BottomSheetFormPayload({
    required this.controller,
    this.hintText,
    this.inputType = TextInputType.text,
    this.validator,
  });
}
