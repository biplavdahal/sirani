import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/authentication/authentication.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class ForgetPasswordFragment extends StatelessWidget {
  final AuthenticationModel model;

  const ForgetPasswordFragment(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.forgotPasswordFormKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            InputField(
              labelText: "Register Email",
              controller: model.forgotPasswordEmailController,
              inputType: TextInputType.emailAddress,
              validator: Validators().validateEmail,
            ),
            const SizedBox(
              height: 18,
            ),
            PrimaryButton(
              label: "Reset Password",
              onPressed: model.onForgotPasswordPressed,
            ),
          ],
        ),
      ),
    );
  }
}
