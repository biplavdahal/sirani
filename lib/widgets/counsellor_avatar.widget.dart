import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/counsellor.data.dart';
import 'package:mysirani/theme.dart';

class CounsellorAvatar extends StatelessWidget {
  final CounsellorData counsellor;

  const CounsellorAvatar(this.counsellor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColor.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CachedNetworkImage(
            height: 140,
            width: 110,
            imageUrl: auImageBaseUrl + counsellor.profile.avatarUrl!,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Center(
              child: Text(
                counsellor.profile.username[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColor.primary,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: -10,
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: counsellor.status == "Offline"
                    ? Colors.grey
                    : Colors.greenAccent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: counsellor.status == "Offline"
                      ? Colors.white
                      : Colors.green,
                )),
          ),
        ),
      ],
    );
  }
}
