import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/helpers/format_currenecy.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/chat_plans/chat_plans.view.dart';
import 'package:mysirani/views/chats_list/chats_list.view.dart';
import 'package:mysirani/views/counsellor_profile/counsellor_profile.argument.dart';
import 'package:mysirani/views/counsellor_profile/counsellor_profile.view.dart';
import 'package:mysirani/views/dashboard/fragments/profile/profile.model.dart';
import 'package:mysirani/views/dashboard/fragments/profile/widgets/menu_item.widget.dart';
import 'package:mysirani/views/dashboard/fragments/profile/widgets/profile_header.widget.dart';
import 'package:mysirani/views/load_fund/load_fund.view.dart';
import 'package:mysirani/views/manage_schedule/manage_schedule.view.dart';
import 'package:mysirani/views/user_pacakge/user_package.view.dart';
import 'package:mysirani/views/user_profile/user_profile.view.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class ProfileFragment extends StatelessWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<ProfileModel>(
      onModelReady: (model) => model.init(),
      killViewOnClose: false,
      builder: (ctx, model, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(),
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // SECTION:: My Sirani Wallet

                    if (locator<AuthenticationService>().isNormalUser)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Rs. ${formatCurrency(locator<AuthenticationService>().auth!.balance)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: model.isBusyWidget('user-amount')
                                          ? null
                                          : () {
                                              model.refreshAmount();
                                            },
                                      child: model.isBusyWidget('user-amount')
                                          ? const CupertinoActivityIndicator()
                                          : const Icon(MdiIcons.refresh),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const Text("My Sirani Wallet")
                              ],
                            ),
                          ),
                          Expanded(
                            child: PrimaryButton(
                              label: "Load Fund",
                              onPressed: () async {
                                await model.goto(LoadFundView.tag);
                                model.setIdle();
                              },
                              backgroundColor: Colors.green,
                            ),
                          )
                        ],
                      ),

                    if (locator<AuthenticationService>().isNormalUser)
                      const SizedBox(
                        height: 18,
                      ),

                    // SECTION:: User sessions stats
                    if (locator<AuthenticationService>().isNormalUser)
                      if (model.isBusyWidget("user-stats"))
                        const CupertinoActivityIndicator()
                      else
                        Card(
                          color: Colors.white,
                          margin: const EdgeInsets.all(0),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        model.freeSession!
                                            .remainingVolunteerSession
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      const Text(
                                        "Free Session (Volunteer)",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                  height: 25,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    color: Colors.black12,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        model.freeSession!
                                            .remainingBuddiesSession
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      const Text(
                                        "Free Session (Buddies)",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),

              // SECTION:: Profile menus

              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 16, right: 16),
                shrinkWrap: true,
                childAspectRatio: 16.w / 10.h,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                crossAxisCount: 2,
                children: [
                  MenuItem(
                    
                    
                    onPressed: () async {
                      if (locator<AuthenticationService>().isNormalUser) {
                        await model.goto(UserProfileView.tag);
                      } else {
                        await model.goto(
                          CounsellorProfileView.tag,
                          arguments: CounsellorProfileArgument(null),
                        );
                      }
                      model.setIdle();
                    },
                    icon: const Icon(
                      MdiIcons.account,
                    ),
                    title: "Profile Detail",
                    subtitle: "View profile",
                  ),
                  if (locator<AuthenticationService>().isNormalUser)
                    MenuItem(
                      onPressed: () {
                        model.goto(UserPackageView.tag);
                      },
                      icon: const Icon(
                        MdiIcons.packageUp,
                      ),
                      title: "My Packages",
                      subtitle: "View packages",
                    ),
                  if (locator<AuthenticationService>().isNormalUser)
                    MenuItem(
                      onPressed: () async {
                        await model.goto(ChatPlansView.tag);
                        model.setIdle();
                      },
                      icon: const Icon(
                        MdiIcons.playlistStar,
                      ),
                      title: "Chat Plans",
                      subtitle: "View chat plans",
                    ),
                  if (!locator<AuthenticationService>().isNormalUser)
                    MenuItem(
                      onPressed: () async {
                        await model.goto(ChatsListView.tag);
                        model.setIdle();
                      },
                      icon: const Icon(
                        MdiIcons.messageBulleted,
                      ),
                      title: "Chat List",
                      subtitle: "View chat list",
                    ),
                  if (!locator<AuthenticationService>().isNormalUser)
                    MenuItem(
                      onPressed: () {
                        model.goto(ManageScheduleView.tag);
                      },
                      icon: const Icon(
                        MdiIcons.calendarAccount,
                      ),
                      title: "Manage Schedules",
                      subtitle: "View schedules",
                    ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
