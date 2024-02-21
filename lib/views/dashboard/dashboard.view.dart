import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/constants/page_slugs.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/dashboard/dashboard.model.dart';
import 'package:mysirani/views/notification/notification.view.dart';
import 'package:mysirani/views/ms_page/ms_page.argument.dart';
import 'package:mysirani/views/ms_page/ms_page.view.dart';

class DashboardView extends StatelessWidget {
  static String tag = "dashboard-view";

  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<DashboardModel>(
      builder: (ctx, model, child) {
        return Scaffold(
          key: model.scaffold,
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    model.scaffold.currentState!.openDrawer();
                  },
                  icon: const Icon(MdiIcons.menuOpen),
                );
              },
            ),
            title: Text(model.fragment.title),
            actions: [
              IconButton(
                onPressed: () {
                  model.goto(NotificationView.tag);
                },
                icon: const Icon(MdiIcons.bellOutline),
              ),
              if (model.fragment.showShowMoreOption)
                PopupMenuButton<String>(
                  onSelected: model.moreActions,
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<String>(
                        value: "programs",
                        child: Text('Programs'),
                      ),
                      const PopupMenuItem<String>(
                        value: "self_post",
                        child: Text('Self Post'),
                      ),
                      if (locator<AuthenticationService>().isNormalUser)
                        const PopupMenuItem<String>(
                          value: "free_sessions",
                          child: Text('Free Session'),
                        ),
                      const PopupMenuItem<String>(
                        value: "logout",
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ];
                  },
                ),
            ],
          ),
          drawer: Drawer(
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DrawerHeader(
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 45,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "My Sirani",
                      ),
                      Text(
                        "Version ${model.packageInfo.version}",
                        style: Theme.of(context).textTheme.overline!.copyWith(
                              color: AppColor.secondaryTextColor,
                            ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "SUPPORT",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: AppColor.primaryTextColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                          ),
                        ),
                        ListTile(
                          title: const Text("How To Use App"),
                          leading: const Icon(
                            MdiIcons.informationOutline,
                            color: AppColor.primaryTextColor,
                            size: 28,
                          ),
                          onTap: () {
                            model.goto(
                              MSPageView.tag,
                              arguments: MSPageArgument(
                                  title: "How To Use App",
                                  slug: slugHowToUseApp),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("About Mental Health"),
                          leading: const Icon(
                            MdiIcons.emoticonHappyOutline,
                            color: AppColor.primaryTextColor,
                            size: 28,
                          ),
                          onTap: () {
                            model.goto(
                              MSPageView.tag,
                              arguments: MSPageArgument(
                                title: "About Mental Health",
                                slug: slugAboutMentalHealth,
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("FAQ's"),
                          leading: const Icon(
                            MdiIcons.forumOutline,
                            color: AppColor.primaryTextColor,
                            size: 28,
                          ),
                          onTap: () {
                            model.goto(
                              MSPageView.tag,
                              arguments: MSPageArgument(
                                title: "FAQ's",
                                slug: slugFaqs,
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "LEGAL",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: AppColor.primaryTextColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                          ),
                        ),
                        ListTile(
                          title: const Text("Terms & Condition"),
                          leading: const Icon(
                            MdiIcons.fileOutline,
                            color: AppColor.primaryTextColor,
                            size: 28,
                          ),
                          onTap: () {
                            model.goto(
                              MSPageView.tag,
                              arguments: MSPageArgument(
                                title: "Terms & Condition",
                                slug: slugTermsAndCondition,
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Privacy Policies"),
                          leading: const Icon(
                            MdiIcons.shieldLockOutline,
                            color: AppColor.primaryTextColor,
                            size: 28,
                          ),
                          onTap: () {
                            model.goto(
                              MSPageView.tag,
                              arguments: MSPageArgument(
                                title: "Privacy Policy",
                                slug: slugPrivacyPolicy,
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "HELP ",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: AppColor.primaryTextColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                          ),
                        ),
                        ListTile(
                          title: const Text("About Us"),
                          leading: const Icon(
                            MdiIcons.commentQuestionOutline,
                            color: AppColor.primaryTextColor,
                            size: 28,
                          ),
                          onTap: () {
                            model.goto(
                              MSPageView.tag,
                              arguments: MSPageArgument(
                                title: "About Us",
                                slug: slugAboutUs,
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Contact Us"),
                          leading: const Icon(
                            MdiIcons.helpCircleOutline,
                            color: AppColor.primaryTextColor,
                            size: 28,
                          ),
                          onTap: () {
                            model.goto(
                              MSPageView.tag,
                              arguments: MSPageArgument(
                                title: "Contact Us",
                                slug: slugContactUs,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 0,
            currentIndex: model.currentFragment,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: AppColor.primary,
            unselectedItemColor: AppColor.secondaryTextColor,
            onTap: (value) => model.currentFragment = value,
            selectedFontSize: 12,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(MdiIcons.homeRoof),
                label: "Home",
              ),
              if (locator<AuthenticationService>().isNormalUser)
                const BottomNavigationBarItem(
                  icon: Icon(MdiIcons.accountGroupOutline),
                  label: "Counsellors",
                ),
              const BottomNavigationBarItem(
                icon: Icon(MdiIcons.calendarMonthOutline),
                label: "Appointments",
              ),
              const BottomNavigationBarItem(
                icon: Icon(MdiIcons.semanticWeb),
                label: "Resources",
              ),
              const BottomNavigationBarItem(
                icon: Icon(MdiIcons.accountOutline),
                label: "Profile",
              ),
            ],
          ),
          body: model.fragment.view,
        );
      },
    );
  }
}
