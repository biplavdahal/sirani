import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Icon? icon;

  const SecondaryButton(
      {Key? key, required this.label, this.onPressed, this.color, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: icon == null
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                primary: color ?? AppColor.primaryTextColor,
              ),
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: onPressed,
            )
          : OutlinedButton.icon(
              icon: icon!,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                primary: color,
              ),
              label: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: onPressed,
            ),
    );
  }
}
