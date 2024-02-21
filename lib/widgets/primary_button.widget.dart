import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const PrimaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: backgroundColor ?? AppColor.primary,
          onPrimary: backgroundColor != null
              ? (backgroundColor!.computeLuminance() > 0.5
                  ? AppColor.primaryTextColor
                  : AppColor.primaryButtonTextColor)
              : AppColor.primaryButtonTextColor,
        ),
        onPressed: onPressed,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
