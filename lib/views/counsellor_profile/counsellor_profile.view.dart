import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/change_password/change_password.view.dart';
import 'package:mysirani/views/counsellor_profile/counsellor_profile.argument.dart';
import 'package:mysirani/views/counsellor_profile/counsellor_profile.model.dart';
import 'package:mysirani/views/counsellor_profile/fragment/counsellor_detail.fragment.dart';
import 'package:mysirani/views/counsellor_profile/fragment/counsellor_reviews.fragment.dart';
import 'package:mysirani/views/counsellor_profile/fragment/counsellor_schedule.fragment.dart';
import 'package:mysirani/views/dashboard/fragments/counsellors/widgets/counsellor_item.widget.dart';
import 'package:mysirani/views/edit_profile/edit_profile.view.dart';

class CounsellorProfileView extends StatefulWidget {
  static String tag = 'counsellor-profile-view';

  final Arguments? arguments;

  const CounsellorProfileView(this.arguments, {Key? key}) : super(key: key);

  @override
  _CounsellorProfileViewState createState() => _CounsellorProfileViewState();
}

class _CounsellorProfileViewState extends State<CounsellorProfileView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return View<CounsellorProfileModel>(
      onModelReady: (model) => model.init(
        widget.arguments as CounsellorProfileArgument,
        vsync: this,
      ),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: AppColor.primary,
          appBar: AppBar(
            actions: model.isSelf
                ? [
                    IconButton(
                      onPressed: () async {
                        await model.goto(EditProfileView.tag);
                        model.refreshProfile();
                      },
                      icon: const Icon(MdiIcons.accountEditOutline),
                    ),
                    if (!locator<AuthenticationService>().isSocialUser)
                      IconButton(
                        onPressed: () async {
                          await model.goto(ChangePasswordView.tag);
                          model.setIdle();
                        },
                        icon: const Icon(MdiIcons.formTextboxPassword),
                      ),
                  ]
                : [
                    if (!model.isLoading)
                      IconButton(
                        onPressed: model.onRateCounsellorPressed,
                        icon: const Icon(
                          MdiIcons.starOutline,
                        ),
                      ),
                    IconButton(
                      onPressed: !model.isBusyWidget("like") &&
                              model.counsellor.hasLiked == "No"
                          ? model.onLikePressed
                          : null,
                      icon: model.isBusyWidget("like")
                          ? const CupertinoActivityIndicator()
                          : Icon(
                              model.counsellor.hasLiked == "No"
                                  ? MdiIcons.heartOutline
                                  : MdiIcons.heart,
                              color: Colors.white,
                            ),
                    ),
                  ],
          ),
          body: Column(
            children: [
              CounsellorItem(
                model.counsellor,
                removeBackgroundColor: true,
                onBookAppointmentPressed: model.isSelf
                    ? null
                    : () => model.onBookAnAppointmentPressed(),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          TabBar(
                            controller: model.tabController,
                            indicatorColor: AppColor.accent,
                            unselectedLabelColor:
                                AppColor.primary.withOpacity(0.5),
                            labelColor: AppColor.primary,
                            isScrollable: true,
                            tabs: const [
                              Tab(
                                text: "Details",
                              ),
                              Tab(
                                text: "Schedules",
                              ),
                              Tab(
                                text: "Rating / Reviews",
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: model.tabController,
                              children: [
                                CounsellorDetail(model.counsellor.profile),
                                if (model.isLoading)
                                  const LinearProgressIndicator(
                                    color: Colors.grey,
                                    backgroundColor: Colors.blueGrey,
                                  )
                                else
                                  CounsellorSchedule(
                                      model.counsellor.schedules),
                                if (model.isLoading)
                                  const LinearProgressIndicator(
                                    color: Colors.grey,
                                    backgroundColor: Colors.blueGrey,
                                  )
                                else
                                  CounsellorReviews(model.counsellor.reviews!)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -20,
                      right: 0,
                      left: 0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            if (model.counsellor.profile.videoDisplay != null &&
                                model.counsellor.profile.videoDisplay == 1)
                              const Chip(
                                visualDensity: VisualDensity.compact,
                                label: Text("Video Call"),
                                avatar: Icon(
                                  MdiIcons.videoOutline,
                                  color: AppColor.primary,
                                ),
                                labelStyle: TextStyle(
                                  color: AppColor.primary,
                                ),
                                elevation: 2,
                                backgroundColor: Colors.white,
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (model.counsellor.profile.chatDisplay != null &&
                                model.counsellor.profile.chatDisplay == 1)
                              const Chip(
                                visualDensity: VisualDensity.compact,
                                label: Text("Chat"),
                                avatar: Icon(
                                  MdiIcons.chatOutline,
                                  color: AppColor.primary,
                                ),
                                labelStyle: TextStyle(
                                  color: AppColor.primary,
                                ),
                                elevation: 2,
                                backgroundColor: Colors.white,
                              ),
                            const Spacer(),
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text(
                                  model.counsellor.likes.length.toString()),
                              avatar: const Icon(
                                MdiIcons.heart,
                                color: Colors.red,
                              ),
                              labelStyle: const TextStyle(
                                color: AppColor.primary,
                              ),
                              elevation: 2,
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
