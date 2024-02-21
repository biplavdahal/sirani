import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/user.data.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/widgets/user_avatar.widget.dart';

class UserProfileHeader extends StatelessWidget {
  UserProfileHeader({Key? key}) : super(key: key);

  final UserData _user = locator<AuthenticationService>().auth!.user;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      UserAvatar(
        user: _user,
        size: 48,
        borderWidth: 2,
        borderColor: Colors.white,
      ),
      const SizedBox(height: 10),
      Text(
        _user.fullName ?? _user.displayName!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        _user.email,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        _user.mobile ?? "",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    ]);
  }
}
