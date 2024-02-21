import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/user.data.dart';
import 'package:mysirani/theme.dart';

class UserAvatar extends StatelessWidget {
  final UserData user;
  final File? tempImage;
  final double size;
  final double borderWidth;
  final Color borderColor;

  const UserAvatar({
    Key? key,
    required this.user,
    this.size = 24,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.tempImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tempImage != null) {
      return CircleAvatar(
        radius: size + borderWidth,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: size,
          backgroundColor: AppColor.primary.withOpacity(0.5),
          backgroundImage: FileImage(tempImage!),
        ),
      );
    }

    if (user.avatarUrl == null || user.avatarUrl == "") {
      return CircleAvatar(
        radius: size + borderWidth,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: size,
          backgroundColor: AppColor.primary.withOpacity(0.5),
          backgroundImage: const AssetImage("assets/images/logo.png"),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: auImageBaseUrl + user.avatarUrl!,
      errorWidget: (context, url, error) => CircleAvatar(
        radius: size + borderWidth,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: size,
          backgroundColor: AppColor.primary.withOpacity(0.5),
          backgroundImage: const AssetImage("assets/images/logo.png"),
        ),
      ),
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(
          radius: size + borderWidth,
          backgroundColor: borderColor,
          child: CircleAvatar(
            backgroundImage: imageProvider,
            radius: size,
            backgroundColor: AppColor.primary.withOpacity(0.5),
          ),
        );
      },
    );
  }
}
