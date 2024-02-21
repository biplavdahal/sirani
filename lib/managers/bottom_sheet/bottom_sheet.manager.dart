import 'package:bestfriend/bestfriend.dart';
import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.service.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/chat_plans/widgets/chat_plan_item.widget.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';
import 'package:mysirani/widgets/rating_bar.widget.dart';

class BottomSheetManager extends StatefulWidget {
  final Widget body;

  const BottomSheetManager({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  _BottomSheetManagerState createState() => _BottomSheetManagerState();
}

class _BottomSheetManagerState extends State<BottomSheetManager>
    with SingleTickerProviderStateMixin {
  final BottomSheetService _sheetService = locator<BottomSheetService>();
  double _rating = 0;

  @override
  void initState() {
    super.initState();

    _sheetService.registerSheetListener(_showBottomSheet);
  }

  void _showBottomSheet(BottomSheetRequest request) {
    if (request.type == BottomSheetType.form) {
      _baseBottomSheet(
        child: _formTypeBuilder(request),
        isDismissable: request.dismissable,
      );
    }

    if (request.type == BottomSheetType.confirmation) {
      _baseBottomSheet(
        child: _confirmationTypeBuilder(request),
        isDismissable: request.dismissable,
      );
    }

    if (request.type == BottomSheetType.chatPlanPayment) {
      _baseBottomSheet(
        child: _chatPlanTypeBuilder(request),
        isDismissable: request.dismissable,
      );
    }

    if (request.type == BottomSheetType.mediaSource) {
      _baseBottomSheet(
        child: _mediaSourceTypeBuilder(request),
        isDismissable: request.dismissable,
      );
    }
  }

  _baseBottomSheet({required Widget child, required bool isDismissable}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.scaffold,
      elevation: 5,
      isDismissible: isDismissable,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36),
          topLeft: Radius.circular(36),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      builder: (context) => BottomSheet(
        onClosing: () {
          Navigator.pop(context);
        },
        enableDrag: false,
        builder: (context) => Container(
          color: AppColor.scaffold,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _formTypeBuilder(BottomSheetRequest request) {
    _rating = 1;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.title,
          ),
          SizedBox(
            height: 10.h,
          ),
          if (request.description != null)
            Text(
              request.description!,
              style: Theme.of(context).textTheme.caption,
            ),
          if (request.addRatingBar)
            const SizedBox(
              height: 28,
            ),
          if (request.addRatingBar)
            StatefulBuilder(
              builder: (context, setState) {
                return Align(
                  alignment: Alignment.center,
                  child: RatingBar(
                    selectedRating: _rating,
                    onRatingChanged: (rating) {
                      _rating = rating;
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          SizedBox(
            height: 28.h,
          ),
          Form(
            key: request.formKey,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final payload =
                    request.payload[index] as BottomSheetFormPayload;
                payload.controller.clear();

                return InputField(
                  controller: payload.controller,
                  isPassword:
                      payload.inputType == TextInputType.visiblePassword,
                  labelText: payload.hintText!,
                  inputType: payload.inputType,
                  validator: payload.validator,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10.h,
                );
              },
              itemCount: request.payload.length,
            ),
          ),
          if (request.showPositiveButtonLabel) ...[
            SizedBox(
              height: 22.h,
            ),
            PrimaryButton(
              onPressed: () {
                if ((request.formKey!.currentState!).validate()) {
                  _sheetService.hideBottomSheet(
                    BottomSheetResponse(
                      result: request.addRatingBar ? _rating : true,
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              label: request.positiveButtonLabel,
            ),
          ],
        ],
      ),
    );
  }

  Widget _confirmationTypeBuilder(BottomSheetRequest request) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          request.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(request.description!),
        const SizedBox(
          height: 22,
        ),
        PrimaryButton(
          onPressed: () {
            _sheetService.hideBottomSheet(
              BottomSheetResponse(result: true),
            );
            Navigator.pop(context);
          },
          label: request.positiveButtonLabel,
        ),
        const SizedBox(
          height: 10,
        ),
        PrimaryButton(
          backgroundColor: Colors.red,
          onPressed: () {
            _sheetService.hideBottomSheet(
              BottomSheetResponse(result: false),
            );
            Navigator.pop(context);
          },
          label: request.negativeButtonLabel,
        ),
      ],
    );
  }

  Widget _chatPlanTypeBuilder(BottomSheetRequest request) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChatPlanItem(plan: (request.payload as ChatPlanPayload).plan),
        const SizedBox(
          height: 18,
        ),
        PrimaryButton(
          label: "Pay from balance",
          onPressed: locator<AuthenticationService>().auth!.balance <
                  (request.payload as ChatPlanPayload).planRate
              ? null
              : () {
                  _sheetService
                      .hideBottomSheet(BottomSheetResponse(result: true));
                  Navigator.pop(context);
                },
        ),
        if (locator<AuthenticationService>().auth!.balance <
            (request.payload as ChatPlanPayload).planRate)
          const SizedBox(
            height: 8,
          ),
        if (locator<AuthenticationService>().auth!.balance <
            (request.payload as ChatPlanPayload).planRate)
          const Text(
            "You don't have sufficient balance to pay from My Sirani Balance.",
            style: TextStyle(
              color: AppColor.secondaryTextColor,
              fontSize: 11,
            ),
          ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ESewaPaymentButton(
                locator<ESewaPnp>(),
                amount:
                    (request.payload as ChatPlanPayload).planRate.toDouble(),
                productId:
                    (request.payload as ChatPlanPayload).plan.id.toString(),
                productName: (request.payload as ChatPlanPayload).plan.title,
                callBackURL: "https://app.mysirani.com/",
                onSuccess: (result) {
                  Navigator.pop(context);
                  (request.payload as ChatPlanPayload).onESewaSuccess(result);
                },
                onFailure: (exception) {
                  Navigator.pop(context);
                  (request.payload as ChatPlanPayload).onEsewaError(exception);
                },
                width: double.infinity,
                color: Colors.green,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _mediaSourceTypeBuilder(BottomSheetRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Choose image source...",
          style: TextStyle(
            fontSize: 12,
            color: AppColor.secondaryTextColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () {
            _sheetService.hideBottomSheet(
              BottomSheetResponse(result: "c"),
            );
            Navigator.pop(context);
          },
          title: const Text("Camera"),
          leading: const Icon(Icons.camera_alt),
          dense: true,
        ),
        const Divider(),
        ListTile(
          onTap: () {
            _sheetService.hideBottomSheet(
              BottomSheetResponse(result: "g"),
            );
            Navigator.pop(context);
          },
          title: const Text("Gallery"),
          leading: const Icon(Icons.photo_library),
          dense: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.body;
  }
}
