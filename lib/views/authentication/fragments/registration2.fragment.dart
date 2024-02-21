import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/views/authentication/authentication.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/link_text.widget.dart';
import 'package:mysirani/widgets/ms_checkbox.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class Registration2Fragment extends StatelessWidget {
  final AuthenticationModel model;

  const Registration2Fragment(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.signup2FormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  model.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            InputField(
              labelText: "Username",
              controller: model.signUp2UsernameController,
              validator: FieldValidator.isRequired,
            ),
            const SizedBox(
              height: 12,
            ),
            InputField(
              labelText: "Password",
              isPassword: true,
              controller: model.signUp2PasswordController,
              validator: Validators().validatePassword,
            ),
            const SizedBox(
              height: 12,
            ),
            InputField(
              labelText: "Confirm Password",
              isPassword: true,
              controller: model.signUp2ConfirmPasswordController,
              validator: (value) => Validators().validateConfirmPassword(
                value,
                model.signUp2PasswordController.text,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            MSCheckBox(
              value: model.signUp2TNC,
              onChanged: (value) => model.signUp2TNC = value,
              label: "I gree",
              child: Text.rich(
                TextSpan(text: "I agree to all ", children: [
                  WidgetSpan(
                    child: LinkText(
                      "terms & condition",
                      onPressed: () {},
                    ),
                  )
                ]),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            PrimaryButton(
              label: "Sign Up",
              onPressed: model.onSignUp2Pressed,
            ),
          ],
        ),
      ),
    );
  }
}
