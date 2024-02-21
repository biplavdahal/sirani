import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/start_up/start_up.model.dart';

class StartUpView extends StatelessWidget {
  static String tag = 'startup-view';

  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<StartUpModel>(
      onModelReady: (model) => model.init(context),
      builder: (ctx, model, child) {
        return SafeArea(
          child: Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Image.asset(
                    "assets/images/logo.png",
                    height: 75.h,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "My Sirani",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primary,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  const CupertinoActivityIndicator(),
                  const Spacer(),
                  Text(
                    "Version ${model.packageInfo.version} (build ${model.packageInfo.buildNumber})",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: AppColor.secondaryTextColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
