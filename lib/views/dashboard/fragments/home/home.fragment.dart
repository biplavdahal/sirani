import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/dashboard/fragments/home/home.model.dart';
import 'package:mysirani/views/dashboard/fragments/home/widgets/feeling_brief.widget.dart';
import 'package:mysirani/views/dashboard/fragments/home/widgets/feeling_options.widget.dart';
import 'package:mysirani/widgets/thread_item.widget.dart';
import 'package:mysirani/widgets/user_avatar.widget.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<HomeModel>(
      killViewOnClose: false,
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return RefreshIndicator(
          onRefresh: () => model.init(refresh: true),
          child: SingleChildScrollView(
            controller: model.forumThreadsScrollControrller,
            child: Column(
              children: [
                if (locator<AuthenticationService>().isNormalUser)
                  if (!model.isBusyWidget("feelings"))
                    if (model.feeling == null)
                      FeelingsOptions(
                        onSelected: (feeling) => model.setFeeling(feeling),
                      )
                    else
                      FeelingBreif(),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: model.onShareFeelingPressed,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        UserAvatar(
                            user: locator<AuthenticationService>().auth!.user),
                        const SizedBox(width: 10),
                        const Text(
                          "Share Your Feeling",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!model.isBusyWidget("threads-list"))
                  if (model.threads != null) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final _thread = model.threads![index];

                        return AbsorbPointer(
                          absorbing:
                              model.isBusyWidget("thread-${_thread.data.id}"),
                          child: Opacity(
                            opacity:
                                model.isBusyWidget("thread-${_thread.data.id}")
                                    ? 0.5
                                    : 1,
                            child: ThreadItem(
                              _thread,
                              onLikePressed: () =>
                                  model.setLike(_thread.data.id),
                              onTap: () => model.onForumThreadClick(_thread),
                              likeInProgress: model.isBusyWidget(
                                "${_thread.data.id}-like-btn",
                              ),
                              onActionPressed: model.threadOption,
                            ),
                          ),
                        );
                      },
                      itemCount: model.threads!.length,
                    ),
                    if (model.canLoadMore)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CupertinoActivityIndicator(),
                          SizedBox(width: 10),
                          Text("Loading more...",
                              style: TextStyle(
                                color: AppColor.secondaryTextColor,
                              )),
                        ],
                      ),
                    const SizedBox(height: 10),
                  ] else
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      width: double.infinity,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Something went wrong while fetching data!",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: model.init,
                            child: const Text("Retry"),
                            style: TextButton.styleFrom(
                              primary: AppColor.primary,
                            ),
                          )
                        ],
                      ),
                    )
                else
                  const CupertinoActivityIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
