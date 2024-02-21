import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/counsellor.service.dart';
import 'package:mysirani/services/forum.service.dart';
import 'package:mysirani/services/user.service.dart';
import 'package:mysirani/services/wallet.service.dart';
import 'package:mysirani/views/authentication/authentication.view.dart';
import 'package:mysirani/views/dashboard/data_model/view_info.data.dart';
import 'package:mysirani/views/dashboard/fragments/appointments/appointments.fragment.dart';
import 'package:mysirani/views/dashboard/fragments/counsellors/counsellors.fragment.dart';
import 'package:mysirani/views/dashboard/fragments/home/home.fragment.dart';
import 'package:mysirani/views/dashboard/fragments/profile/profile.fragment.dart';
import 'package:mysirani/views/dashboard/fragments/resources/resources.fragment.dart';
import 'package:mysirani/views/free_sessions/free_sessions.view.dart';
import 'package:mysirani/views/programs/programs.view.dart';
import 'package:mysirani/views/self_post/self_post.view.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DashboardModel extends ViewModel with DialogMixin {
  // Services
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final UserService _userService = locator<UserService>();
  final ForumService _forumService = locator<ForumService>();
  final WalletService _walletService = locator<WalletService>();
  final AppointmentService _appointmentService = locator<AppointmentService>();
  final CounsellorService _counsellorService = locator<CounsellorService>();

  // UI Controllers
  // ...
  int _currentFragment = 0;
  int get currentFragment => _currentFragment;
  set currentFragment(int value) {
    _currentFragment = value;
    setIdle();
  }

  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffold => _scaffold;

  // Data

  // Data
  PackageInfo get packageInfo => locator<PackageInfo>();
  final List<ViewInfoData> _viewInfoData = [
    ViewInfoData(
      title: "Home",
      view: const HomeFragment(),
    ),
    if (locator<AuthenticationService>().isNormalUser)
      ViewInfoData(
        title: "Featured Counsellors",
        view: const CounsellorsFragment(),
      ),
    ViewInfoData(
      title: "Appointments",
      view: const AppointmentsFragment(),
    ),
    ViewInfoData(
      title: "Resources",
      view: const ResoucesFragment(),
    ),
    ViewInfoData(
      title: "Profile",
      view: const ProfileFragment(),
      showShowMoreOption: true,
    ),
  ];

  ViewInfoData get fragment => _viewInfoData[_currentFragment];

  // Action
  void moreActions(String action) {
    switch (action) {
      case "logout":
        _logout();
        break;
      case "programs":
        goto(ProgramsView.tag);
        break;
      case "self_post":
        goto(SelfPostView.tag);
        break;
      case "free_sessions":
        goto(FreeSessionsView.tag);
        break;
    }
  }

  Future<void> _logout() async {
    dialog.showDialog(
      DialogRequest(type: DialogType.progressDialog, title: "Logging out..."),
    );

    await _authenticationService.signOut();
    _userService.clearFeeling();
    _forumService.reset();
    _walletService.reset();
    _appointmentService.reset();
    _counsellorService.clearScheduleCache();
    dialog.hideDialog();

    gotoAndClear(AuthenticationView.tag);
  }
}
