import 'package:bestfriend/bestfriend.dart';
import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:mysirani/data_model/chat_plan.data.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.mixin.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.model.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/user.service.dart';
import 'package:mysirani/services/wallet.service.dart';

class ChatPlansModel extends ViewModel
    with SnackbarMixin, BottomSheetMixin, DialogMixin {
  // Services
  final UserService _userService = locator<UserService>();
  final WalletService _walletService = locator<WalletService>();

  // Data
  List<ChatPlanData> _chatPlans = [];
  List<ChatPlanData> get chatPlans => _chatPlans;

  // Actions
  Future<void> init() async {
    try {
      setLoading();
      _chatPlans = await _userService.getChatPlans();
    } on ErrorData catch (e) {
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: e.response,
          type: ESnackbarType.error,
        ),
      );
    }

    setIdle();
  }

  Future<void> onBuyPressed(
    ChatPlanData plan, {
    required int planRate,
  }) async {
    try {
      final payResponse = await bottomSheet.showBottomSheet(
        BottomSheetRequest<ChatPlanPayload>(
          title: "",
          type: BottomSheetType.chatPlanPayment,
          payload: ChatPlanPayload(
            planRate: planRate,
            plan: plan,
            onESewaSuccess: _onESewaSuccess,
            onEsewaError: _onESewaError,
          ),
        ),
      );

      if (payResponse.result) {
        await _onPayFromBalancePressed(plan);
      }
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }
  }

  Future<void> _onPayFromBalancePressed(ChatPlanData plan) async {
    try {
      // Buy chat plan
      dialog.showDialog(DialogRequest(
          type: DialogType.progressDialog, title: "Buying plan..."));
      await _userService.buyChatPlanWithBalance(plan.id);
      dialog.hideDialog();
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: "${plan.title} bought successfully!",
          type: ESnackbarType.success,
        ),
      );
    } on ErrorData catch (e) {
      dialog.hideDialog();

      errorHandler(snackbar, e: e);
    }
  }

  Future<void> _onESewaSuccess(ESewaResult result) async {
    try {
      // Load fund
      dialog.showDialog(DialogRequest(
          type: DialogType.progressDialog, title: "Loading fund..."));
      await _walletService.loadBalance(
          int.parse(double.parse(result.totalAmount!).toStringAsFixed(0)),
          source: "Esewa");
      dialog.hideDialog();

      // Buy chat plan
      dialog.showDialog(DialogRequest(
          type: DialogType.progressDialog, title: "Buying plan..."));
      await _userService.buyChatPlanWithBalance(int.parse(result.productId!));
      dialog.hideDialog();
      snackbar.displaySnackbar(
        SnackbarRequest.of(
          message: "${result.productName} bought successfully!",
          type: ESnackbarType.success,
        ),
      );
    } on ErrorData catch (e) {
      dialog.hideDialog();

      errorHandler(snackbar, e: e);
    }
  }

  void _onESewaError(ESewaPaymentException e) {
    snackbar.displaySnackbar(
      SnackbarRequest.of(
        message: e.message!,
        type: ESnackbarType.error,
        duration: ESnackbarDuration.long,
      ),
    );
  }
}
