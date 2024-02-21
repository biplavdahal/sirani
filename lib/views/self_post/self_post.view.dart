import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/forum/forum.argument.dart';
import 'package:mysirani/views/forum/forum.view.dart';
import 'package:mysirani/views/self_post/self_post.model.dart';
import 'package:mysirani/widgets/thread_item.widget.dart';

class SelfPostView extends StatelessWidget {
  static String tag = 'self-post-view';

  const SelfPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<SelfPostModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Self Post'),
          ),
          body: model.isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      itemCount: model.threads.length,
                      itemBuilder: (context, index) {
                        final _thread = model.threads[index];
                        return ThreadItem(
                          model.threads[index],
                          likeInProgress:
                              model.isBusyWidget("${_thread.data.id}-like-btn"),
                          onActionPressed: model.threadOption,
                          onLikePressed: () => model.setLike(_thread.data.id),
                          onTap: () {
                            model.goto(
                              ForumView.tag,
                              arguments: ForumArgument(_thread),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }
}
