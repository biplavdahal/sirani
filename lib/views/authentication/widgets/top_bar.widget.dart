import 'package:flutter/material.dart';
import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/views/authentication/data_model/top_bar.data.dart';

class TopBar extends StatelessWidget {
  final TopBarData data;
  final VoidCallback onBackPressed;
  final VoidCallback onSignInPressed;
  final VoidCallback onSignupPressed;

  const TopBar({
    Key? key,
    required this.data,
    required this.onBackPressed,
    required this.onSignInPressed,
    required this.onSignupPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 42.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.enableBack)
                  GestureDetector(
                    onTap: onBackPressed,
                    child: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.white,
                    ),
                  )
                else
                  Image.asset(
                    "assets/images/logo.png",
                    height: 42.h,
                    color: Colors.white,
                  ),
                const Spacer(),
                if (!data.enableBack)
                  linkText(
                    "Sign In",
                    isActive: data.activeSignIn,
                    onPressed: onSignInPressed,
                  ),
                if (!data.enableBack) const SizedBox(width: 8),
                if (!data.enableBack)
                  linkText(
                    "Sign Up",
                    isActive: data.activeSignUp,
                    onPressed: onSignupPressed,
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            data.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            data.subtitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget linkText(String text,
      {required bool isActive, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: isActive ? null : onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
