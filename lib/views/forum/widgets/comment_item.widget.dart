import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/data_model/comment_thread.data.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/widgets/peek_a_boo_text.widget.dart';
import 'package:mysirani/widgets/user_avatar.widget.dart';
import 'package:bestfriend/bestfriend.dart';

class CommentItem extends StatelessWidget {
  final CommentThreadData comment;
  final Future<bool> Function() onDelete;
  final VoidCallback onLikeTap;
  final bool likeInProgress;

  const CommentItem(
    this.comment, {
    Key? key,
    required this.onDelete,
    required this.onLikeTap,
    this.likeInProgress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        onDelete();
      },
      background: Container(
        color: Colors.red,
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        color: AppColor.scaffold,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              MdiIcons.trashCan,
              color: AppColor.primary,
            ),
            SizedBox(width: 8),
            Text("Delete"),
            SizedBox(width: 8),
          ],
        ),
      ),
      direction:
          comment.commentBy == locator<AuthenticationService>().auth!.user
              ? DismissDirection.endToStart
              : DismissDirection.none,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(
              user: comment.commentBy,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.commentBy.fullName ??
                              comment.commentBy.displayName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        PeekABooText(
                          comment.data.body,
                          style: const TextStyle(
                            color: AppColor.secondaryTextColor,
                          ),
                          maxLengthOnCollapse: 175,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        formattedDateTime(comment.data.dateTime),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.secondaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: likeInProgress ? null : onLikeTap,
                        child: likeInProgress
                            ? const CupertinoActivityIndicator()
                            : Icon(
                                comment.hasLiked == "Yes"
                                    ? MdiIcons.heart
                                    : MdiIcons.heartOutline,
                                color: comment.hasLiked == "Yes"
                                    ? Colors.red
                                    : AppColor.secondaryTextColor,
                              ),
                      ),
                      Text(comment.likes),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
