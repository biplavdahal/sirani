import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';

class Section extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Widget child;
  final VoidCallback? onViewMorePressed;
  final bool removePadding;

  const Section({
    Key? key,
    required this.child,
    this.title,
    this.titleStyle,
    this.onViewMorePressed,
    this.removePadding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 21),
      padding: removePadding
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: titleStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColor.secondaryTextColor,
                      ),
                ),
              if (onViewMorePressed != null)
                InkWell(
                  onTap: onViewMorePressed,
                  child: const Text(
                    "View More >>",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                )
            ],
          ),
          if (title != null)
            const SizedBox(
              height: 10,
            ),
          child,
        ],
      ),
    );
  }
}
