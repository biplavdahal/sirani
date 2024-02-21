import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/constants/role_map.dart';
import 'package:mysirani/data_model/user.data.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/widgets/user_avatar.widget.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({Key? key}) : super(key: key);

  final UserData _user = locator<AuthenticationService>().auth!.user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: const BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
          ),
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(20.sp),
              child: Row(
                children: [
                  UserAvatar(
                    user: _user,
                    size: 48.r,
                    borderWidth: 3,
                    borderColor: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user.fullName ?? _user.displayName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role[_user.role] ?? '',
                        style: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
