import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/change_password/change_password.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  static String tag = "change-password-view";

  @override
  Widget build(BuildContext context) {
    return View<ChangePasswordModel>(
      enableTouchRepeal: true,
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Change Password'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: model.formKey,
              child: Column(
                children: [
                  InputField(
                    labelText: "New Password",
                    controller: model.newPasswordController,
                    validator: Validators.validate.validatePassword,
                    isPassword: true,
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    labelText: "Confirm Password",
                    controller: model.confirmPasswordController,
                    validator: (confirm) => Validators.validate
                        .validateConfirmPassword(
                            confirm, model.newPasswordController.text),
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: "Set new password",
                    onPressed: model.onSetNewPasswordPressed,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
