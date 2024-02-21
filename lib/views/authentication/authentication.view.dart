import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/authentication/authentication.model.dart';
import 'package:mysirani/views/authentication/fragments/forget_password.fragment.dart';
import 'package:mysirani/views/authentication/fragments/login.fragment.dart';
import 'package:mysirani/views/authentication/fragments/registration1.fragment.dart';
import 'package:mysirani/views/authentication/fragments/registration2.fragment.dart';
import 'package:mysirani/views/authentication/widgets/top_bar.widget.dart';

class AuthenticationView extends StatefulWidget {
  static String tag = "authentication-view";

  const AuthenticationView({Key? key}) : super(key: key);

  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return View<AuthenticationModel>(
      enableTouchRepeal: true,
      onModelReady: (model) => model.init(tickerProvider: this),
      builder: (ctx, model, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColor.primary,
            body: Column(
              children: [
                TopBar(
                  data: model.topBarData,
                  onBackPressed: () {
                    model.gotoTab(1);
                  },
                  onSignInPressed: () {
                    model.gotoTab(0);
                  },
                  onSignupPressed: () {
                    model.gotoTab(1);
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: model.tabController,
                        children: [
                          LoginFragment(model),
                          Registration1Fragment(model),
                          Registration2Fragment(model),
                          ForgetPasswordFragment(model),
                        ],
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
