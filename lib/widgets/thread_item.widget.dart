import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/data_model/forum_thread.data.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/widgets/peek_a_boo_text.widget.dart';
import 'package:mysirani/widgets/user_avatar.widget.dart';

class ThreadItem extends StatelessWidget {
  final ForumThreadData thread;
  final VoidCallback? onLikePressed;
  final VoidCallback? onTap;
  final Function(String, ForumThreadData)? onActionPressed;
  final bool likeInProgress;

  const ThreadItem(
    this.thread, {
    Key? key,
    this.onLikePressed,
    this.onTap,
    this.likeInProgress = false,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: onTap == null
          ? EdgeInsets.zero
          : const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (thread.data.isAnonymous == null ||
                        thread.data.isAnonymous == 0)
                      UserAvatar(user: thread.postBy)
                    else
                      Image.asset(
                        "assets/images/logo.png",
                        height: 48,
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (thread.data.isAnonymous == null ||
                            thread.data.isAnonymous == 0)
                          Text(
                            thread.postBy.fullName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          const Text(
                            "My Sirani User",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          formattedDateTime(thread.data.dateTime),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColor.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (onTap != null)
                      PopupMenuButton<String>(
                        child: const Icon(MdiIcons.dotsHorizontal),
                        padding: EdgeInsets.zero,
                        onSelected: (value) =>
                            onActionPressed?.call(value, thread),
                        itemBuilder: (context) {
                          return [
                            if (thread.postBy.id ==
                                locator<AuthenticationService>().auth!.userId)
                              const PopupMenuItem<String>(
                                value: "EDIT",
                                child: Text('Edit'),
                                padding: EdgeInsets.symmetric(horizontal: 14),
                              ),
                            if (thread.postBy.id ==
                                locator<AuthenticationService>().auth!.userId)
                              const PopupMenuItem<String>(
                                value: "DELETE",
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 14),
                              ),
                            const PopupMenuItem<String>(
                              value: "ISSUE",
                              child: Text('Issue A Problem'),
                              padding: EdgeInsets.symmetric(horizontal: 14),
                            ),
                            const PopupMenuItem<String>(
                              value: "REPORT",
                              child: Text('Report An Issue'),
                              padding: EdgeInsets.symmetric(horizontal: 14),
                            ),
                          ];
                        },
                      )
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                if (onTap != null)
                  PeekABooText(
                    thread.data.description,
                    maxLengthOnCollapse: 100,
                  )
                else
                  Text(thread.data.description),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: likeInProgress ? null : onLikePressed,
                style: TextButton.styleFrom(
                  primary: thread.hasLiked == "1"
                      ? Colors.red
                      : AppColor.primaryTextColor,
                ),
                icon: likeInProgress
                    ? const CupertinoActivityIndicator()
                    : const Icon(MdiIcons.heart),
                label:
                    Text("${thread.totalLikes}${onTap == null ? "" : " Like"}"),
              ),
              TextButton.icon(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  primary: AppColor.primaryTextColor,
                ),
                icon: const Icon(MdiIcons.commentTextMultiple),
                label: Text(
                    "${thread.totalComments}${onTap == null ? "" : " Comments"}"),
              )
            ],
          )
        ],
      ),
    );
  }
}
