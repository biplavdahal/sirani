import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/theme.dart';

class RatingBar extends StatelessWidget {
  final double selectedRating;
  final ValueChanged<double> onRatingChanged;

  const RatingBar({
    Key? key,
    required this.selectedRating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: List<Widget>.generate(
        5,
        (index) {
          return GestureDetector(
            onTap: () {
              onRatingChanged(index + 1);
            },
            child: Icon(
              MdiIcons.star,
              size: 32,
              color: selectedRating >= index + 1
                  ? AppColor.accent
                  : AppColor.accent.withOpacity(0.2),
            ),
          );
        },
      ),
    );
  }
}
