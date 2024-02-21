import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/edit_profile/edit_profile.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';
import 'package:mysirani/widgets/user_avatar.widget.dart';

class EditProfileView extends StatelessWidget {
  static String tag = 'edit-profile-view';

  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<EditProfileModel>(
      enableTouchRepeal: true,
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: AppColor.primary,
          appBar: AppBar(),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: model.onChangeProfilePicturePressed,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      UserAvatar(
                        user: locator<AuthenticationService>().auth!.user,
                        tempImage: model.newProfileImage,
                        size: 32,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            MdiIcons.camera,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: model.formKey,
                        child: Column(
                          children: [
                            InputField(
                              labelText: "Full name",
                              controller: model.fullnameController,
                              validator: FieldValidator.isRequired,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InputField(
                              labelText: "Mobile",
                              controller: model.mobileController,
                              maxLength: 10,
                              inputType: TextInputType.phone,
                              validator:
                                  Validators.validate.validatePhoneNumber,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InputField(
                              labelText: "Address",
                              inputType: TextInputType.streetAddress,
                              controller: model.addressController,
                              validator: FieldValidator.isRequired,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (!locator<AuthenticationService>()
                                .isNormalUser) ...[
                              InputField(
                                labelText: "Education",
                                controller: model.educationController,
                                validator: FieldValidator.isRequired,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InputField(
                                labelText: "Skills",
                                controller: model.skillsController,
                                validator: FieldValidator.isRequired,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InputField(
                                labelText: "Experience",
                                controller: model.experienceController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InputField(
                                labelText: "Language",
                                controller: model.languageController,
                                validator: FieldValidator.isRequired,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InputField(
                                labelText: "Introduction",
                                controller: model.introductionController,
                                validator: FieldValidator.isRequired,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InputField(
                                labelText: "Designation",
                                controller: model.designationController,
                                validator: FieldValidator.isRequired,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                            const SizedBox(
                              height: 10,
                            ),
                            PrimaryButton(
                              label: "Update",
                              onPressed: model.onUpdatePressed,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
