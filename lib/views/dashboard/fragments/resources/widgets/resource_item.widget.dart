import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/resource.data.dart';
import 'package:mysirani/theme.dart';
import 'package:bestfriend/bestfriend.dart';

class ResourceItem extends StatelessWidget {
  final VoidCallback? onTap;
  final ResourceData blog;
  final bool isVideo;

  const ResourceItem(this.blog, {Key? key, this.onTap, this.isVideo = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: auImageBaseUrl + blog.image,
                    fit: BoxFit.cover,
                    height: 115.h,
                  ),
                ),
                if (isVideo)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 115.h,
                      width: double.infinity,
                      child: const Icon(
                        MdiIcons.playCircle,
                        color: Colors.white,
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              blog.blogsName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
