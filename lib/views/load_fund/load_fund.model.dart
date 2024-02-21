import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/mixins/snack_bar.mixin.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:esewa_pnp/esewa.dart';
import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/wallet.service.dart';

class LoadFundModel extends ViewModel with DialogMixin, SnackbarMixin {
  // Services
  final WalletService _walletService = locator<WalletService>();

  // UI Components
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  final TextEditingController _amountController = TextEditingController();
  TextEditingController get amountController => _amountController;

  // Action
  Future<void> onLoadFromESewaPressed() async {
    if (_formKey.currentState!.validate()) {
      try {
        ESewaPayment _payment = ESewaPayment(
          amount: double.parse(_amountController.text),
          productName: "Load Fund",
          productID: "load_fund",
          callBackURL: "https://app.mysirani.com/",
        );

        final result = await locator<ESewaPnp>().initPayment(payment: _payment);

        if (result is ESewaResult) {
          dialog.showDialog(
            DialogRequest(
                type: DialogType.progressDialog, title: "Loading fund..."),
          );
          await _walletService.loadBalance(
            int.parse(double.parse(result.totalAmount!).toStringAsFixed(0)),
            source: "Esewa",
          );
          dialog.hideDialog();

          snackbar.displaySnackbar(
            SnackbarRequest.of(
              message:
                  "Rs.${_amountController.text} loaded into your My Sirani Balance.",
              type: ESnackbarType.success,
              duration: ESnackbarDuration.long,
            ),
          );
          goBack();
        }
      } on ErrorData catch (e) {
        dialog.hideDialog();
        errorHandler(snackbar, e: e);
      } on ESewaPaymentException catch (e) {
        snackbar.displaySnackbar(
          SnackbarRequest.of(
            message: e.message!,
            type: ESnackbarType.error,
          ),
        );
      }
    }
  }
}
