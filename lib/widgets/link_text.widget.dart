import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';

class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LinkText(this.text, {Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: AppColor.accent),
      ),
    );
  }
}
