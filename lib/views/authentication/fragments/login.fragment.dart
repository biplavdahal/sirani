import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/authentication/authentication.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/link_text.widget.dart';
import 'package:mysirani/widgets/ms_checkbox.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';
import 'package:mysirani/widgets/secondary_button.widget.dart';

class LoginFragment extends StatelessWidget {
  final AuthenticationModel model;

  const LoginFragment(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.signInFormKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            InputField(
              labelText: "Username",
              controller: model.signInUsernameController,
              validator: FieldValidator.isRequired,
            ),
            const SizedBox(
              height: 12,
            ),
            InputField(
              labelText: "Password",
              isPassword: true,
              controller: model.signInPasswordController,
              validator: FieldValidator.isRequired,
            ),
            const SizedBox(
              height: 18,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: LinkText(
                "Forgot password?",
                onPressed: () => model.gotoTab(3),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: MSCheckBox(
                value: model.signIn2TNC,
                onChanged: (value) => model.signIn2TNC = value,
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
            ),
            const SizedBox(
              height: 18,
            ),
            PrimaryButton(
              label: "Sign In",
              onPressed: model.onSignInPressed,
            ),
            const SizedBox(
              height: 18,
            ),
            const Text(
              "Or you can continue with",
              style: TextStyle(
                color: AppColor.secondaryTextColor,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: "Google",
                    onPressed: model.continueWithGoogle,
                    color: Colors.red,
                    icon: const Icon(
                      MdiIcons.google,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SecondaryButton(
                    icon: const Icon(
                      MdiIcons.facebook,
                    ),
                    color: Colors.blue[800],
                    label: "Facebook",
                    onPressed: model.continueWithFacebook,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
