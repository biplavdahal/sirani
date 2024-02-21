import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/data_model/counsellor.data.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/widgets/counsellor_avatar.widget.dart';
import 'package:mysirani/widgets/secondary_button.widget.dart';

class CounsellorItem extends StatelessWidget {
  final CounsellorData counsellor;
  final VoidCallback? onTap;
  final VoidCallback? onBookAppointmentPressed;
  final bool removeBackgroundColor;

  const CounsellorItem(
    this.counsellor, {
    Key? key,
    this.onTap,
    this.onBookAppointmentPressed,
    this.removeBackgroundColor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: removeBackgroundColor ? Colors.transparent : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CounsellorAvatar(counsellor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (counsellor.profile.type != null &&
                        counsellor.profile.type!.isNotEmpty)
                      Text(
                        counsellor.profile.type!,
                        style: TextStyle(
                          fontSize: 12,
                          color: removeBackgroundColor
                              ? Colors.white54
                              : AppColor.secondaryTextColor,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      counsellor.profile.fullName ??
                          counsellor.profile.displayName!,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: removeBackgroundColor
                            ? Colors.white
                            : AppColor.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          MdiIcons.star,
                          color: AppColor.accent,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${counsellor.rating} / 5",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (onBookAppointmentPressed != null)
                      SecondaryButton(
                        label: "Book an appointment",
                        onPressed: onBookAppointmentPressed,
                        color: Colors.green,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
