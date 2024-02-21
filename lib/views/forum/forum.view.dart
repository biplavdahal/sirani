import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/model/arguments.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/forum/forum.argument.dart';
import 'package:mysirani/views/forum/forum.model.dart';
import 'package:mysirani/views/forum/widgets/comment_item.widget.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/thread_item.widget.dart';

class ForumView extends StatelessWidget {
  final Arguments? arguments;

  static String tag = "forum-view";

  const ForumView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<ForumModel>(
      enableTouchRepeal: true,
      onModelReady: (model) => model.init(arguments! as ForumArgument),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Forum Board (#${model.thread.data.id})"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: model.commentThreadsScrollController,
                  child: Column(
                    children: [
                      ThreadItem(
                        model.thread,
                        onLikePressed: () => model.setLike(
                          model.thread.data.id,
                        ),
                        likeInProgress: model
                            .isBusyWidget("${model.thread.data.id}-like-btn"),
                      ),
                      const Divider(),
                      if (model.isLoading)
                        const CupertinoActivityIndicator()
                      else ...[
                        ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 14,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final _comment = model.comments[index];
                            return CommentItem(
                              _comment,
                              onDelete: () =>
                                  model.onDeleteComment(_comment.data.id),
                              onLikeTap: () =>
                                  model.toggleCommentLike(_comment.data.id),
                              likeInProgress: model
                                  .isBusyWidget("${_comment.data.id}-like-btn"),
                            );
                          },
                          itemCount: model.comments.length,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        if (model.canLoadMore)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CupertinoActivityIndicator(),
                              SizedBox(width: 10),
                              Text(
                                "Loading more...",
                                style: TextStyle(
                                  color: AppColor.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                      ]
                    ],
                  ),
                ),
              ),
              const Divider(),
              Form(
                key: model.commentFormKey,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputField(
                          controller: model.commentTextController,
                          labelText: "Your Comment",
                          validator: FieldValidator.isRequired,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: model.isBusyWidget("comment-btn")
                            ? null
                            : model.onAddCommentPressed,
                        icon: model.isBusyWidget("comment-btn")
                            ? const CupertinoActivityIndicator()
                            : const Icon(MdiIcons.send),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
