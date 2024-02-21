import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/views/authentication/authentication.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class Registration1Fragment extends StatelessWidget {
  final AuthenticationModel model;

  const Registration1Fragment(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.signup1FormKey,
      child: SingleChildScrollView(
        child: Column(
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
            const SizedBox(
              height: 16,
            ),
            InputField(
              labelText: "Full Name",
              controller: model.signup1FullNameController,
              validator: FieldValidator.isRequired,
            ),
            const SizedBox(
              height: 12,
            ),
            InputField(
              labelText: "Email Address",
              inputType: TextInputType.emailAddress,
              controller: model.signUp1EmailController,
              validator: Validators().validateEmail,
            ),
            const SizedBox(
              height: 12,
            ),
            InputField(
              labelText: "Phone Number",
              inputType: TextInputType.phone,
              maxLength: 10,
              controller: model.signUp1PhoneNumberController,
              validator: Validators().validatePhoneNumber,
              prefix: const Text("🇳🇵 "),
            ),
            const SizedBox(
              height: 12,
            ),
            InputField(
              labelText: "Address",
              inputType: TextInputType.streetAddress,
              controller: model.signUp1AddressController,
              validator: FieldValidator.isRequired,
            ),
            const SizedBox(
              height: 18,
            ),
            PrimaryButton(
              label: "Continue",
              onPressed: model.onSignUp1Pressed,
            ),
          ],
        ),
      ),
    );
  }
}
