import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';
import 'package:bestfriend/bestfriend.dart';

class MenuItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: onPressed,
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: AppColor.secondaryTextColor,
                        fontSize: 14.sp,
                      ),
                    ),
                ],
              ))),
    );
  }
}
