import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/data_model/user.data.dart';
import 'package:mysirani/helpers/format_currenecy.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/user_profile/user_profile.model.dart';
import 'package:mysirani/views/user_profile/widgets/user_profile_header.widget.dart';

class UserProfileView extends StatelessWidget {
  UserProfileView({Key? key}) : super(key: key);

  static String tag = 'user-profile-view';
  final UserData? _user = locator<AuthenticationService>().auth?.user;

  @override
  Widget build(BuildContext context) {
    return View<UserProfileModel>(
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: AppColor.primary,
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                onSelected: model.moreOptionActions,
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<String>(
                      value: "wallet_statement",
                      child: Text('My Statement'),
                    ),
                    const PopupMenuItem<String>(
                      value: "update_profile",
                      child: Text('Update Profile'),
                    ),
                    if (!locator<AuthenticationService>().isSocialUser)
                      const PopupMenuItem<String>(
                        value: "change_password",
                        child: Text(
                          'Change Password',
                        ),
                      ),
                  ];
                },
              ),
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                UserProfileHeader(),
                const SizedBox(height: 60),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 50,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Personal Detail",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColor.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Address :\t${_user?.address ?? "N/A"}")
                          ],
                        ),
                      ),
                      Positioned(
                        top: -40,
                        left: 20,
                        right: 20,
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(
                                  MdiIcons.wallet,
                                  color: AppColor.primary,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rs. ${formatCurrency(locator<AuthenticationService>().auth!.balance)}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "My Sirani Balance",
                                      style: TextStyle(
                                        color: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
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
