import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/services/user.service.dart';

class FeelingBreif extends StatelessWidget {
  FeelingBreif({Key? key}) : super(key: key);

  final feeling = locator<UserService>().feeling!;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/feelings/${feeling.type}.png"),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feeling.message,
            ),
          ),
        ],
      ),
    );
  }
}
