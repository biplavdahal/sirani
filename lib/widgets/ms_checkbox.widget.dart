import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';

class MSCheckBox extends StatelessWidget {
  final bool value;
  final String? label;
  final Widget? child;
  final ValueSetter<bool> onChanged;
  final Color? activeColor;
  final TextStyle? labelStyle;

  const MSCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.label,
    this.child,
    this.activeColor,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: label != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color:
                        value == true ? AppColor.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 1,
                      color: value == true
                          ? AppColor.primary
                          : Colors.black.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: value == true
                        ? (activeColor != null
                            ? (activeColor!.computeLuminance() > 0
                                ? Colors.black
                                : Colors.white)
                            : Colors.white)
                        : Colors.white.withOpacity(0),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                if (child == null)
                  if (label != null)
                    Expanded(
                      child: Text(
                        label!,
                      ),
                    )
                  else
                    Container()
                else
                  child!,
              ],
            )
          : AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: value == true ? AppColor.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  width: 1,
                  color: value == true
                      ? AppColor.primary
                      : Colors.white.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.check,
                size: 14,
                color: value == true
                    ? (activeColor != null
                        ? (activeColor!.computeLuminance() > 0
                            ? Colors.black
                            : Colors.white)
                        : Colors.white)
                    : Colors.white.withOpacity(0),
              ),
            ),
    );
  }
}
