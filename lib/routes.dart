import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/appointment_detail/appointment_detail.view.dart';
import 'package:mysirani/views/authentication/authentication.view.dart';
import 'package:mysirani/views/call/call.view.dart';
import 'package:mysirani/views/change_password/change_password.view.dart';
import 'package:mysirani/views/chat_plans/chat_plans.view.dart';
import 'package:mysirani/views/chats_list/chats_list.view.dart';
import 'package:mysirani/views/counsellor_profile/counsellor_profile.view.dart';
import 'package:mysirani/views/create_appointment/create_appointment.view.dart';
import 'package:mysirani/views/dashboard/dashboard.view.dart';
import 'package:mysirani/views/edit_profile/edit_profile.view.dart';
import 'package:mysirani/views/forum/forum.view.dart';
import 'package:mysirani/views/free_sessions/free_sessions.view.dart';
import 'package:mysirani/views/load_fund/load_fund.view.dart';
import 'package:mysirani/views/manage_schedule/manage_schedule.view.dart';
import 'package:mysirani/views/message_board/message_board.view.dart';
import 'package:mysirani/views/notification/notification.view.dart';
import 'package:mysirani/views/onboarding/onboarding.view.dart';
import 'package:mysirani/views/ms_page/ms_page.view.dart';
import 'package:mysirani/views/program/program.view.dart';
import 'package:mysirani/views/programs/programs.view.dart';
import 'package:mysirani/views/resource/resource.view.dart';
import 'package:mysirani/views/resource_list/resource_list.view.dart';
import 'package:mysirani/views/self_post/self_post.view.dart';
import 'package:mysirani/views/start_up/start_up.view.dart';
import 'package:mysirani/views/statement/statement.view.dart';
import 'package:mysirani/views/survey/survey.view.dart';
import 'package:mysirani/views/survey/survey_document.view.dart';
import 'package:mysirani/views/update_schedule/update_schedule.view.dart';
import 'package:mysirani/views/user_pacakge/user_package.view.dart';
import 'package:mysirani/views/user_profile/user_profile.view.dart';
import 'package:mysirani/views/view_survey/view_survey.view.dart';
import 'package:mysirani/views/write_thread/write_thread.view.dart';

Map<String, Widget> routesAndViews(RouteSettings settings) => {
      StartUpView.tag: const StartUpView(),
      OnboardingView.tag: const OnboardingView(),
      AuthenticationView.tag: const AuthenticationView(),
      DashboardView.tag: const DashboardView(),
      ForumView.tag: ForumView(settings.arguments as Arguments?),
      WriteThreadView.tag: WriteThreadView(settings.arguments as Arguments?),
      CounsellorProfileView.tag: CounsellorProfileView(
        settings.arguments as Arguments?,
      ),
      UserProfileView.tag: UserProfileView(),
      ChangePasswordView.tag: const ChangePasswordView(),
      StatementView.tag: const StatementView(),
      UserPackageView.tag: const UserPackageView(),
      ChatPlansView.tag: const ChatPlansView(),
      EditProfileView.tag: const EditProfileView(),
      LoadFundView.tag: const LoadFundView(),
      ResourceView.tag: ResourceView(settings.arguments as Arguments?),
      ResourceListView.tag: ResourceListView(settings.arguments as Arguments?),
      ViewSurveyView.tag: ViewSurveyView(settings.arguments as Arguments?),
      SurveyView.tag: const SurveyView(),
      SurveyDocumentView.tag: const SurveyDocumentView(),
      CreateAppointmentView.tag: const CreateAppointmentView(),
      NotificationView.tag: const NotificationView(),
      MSPageView.tag: MSPageView(settings.arguments as Arguments?),
      ProgramsView.tag: const ProgramsView(),
      ProgramView.tag: ProgramView(settings.arguments as Arguments?),
      FreeSessionsView.tag: const FreeSessionsView(),
      ChatsListView.tag: const ChatsListView(),
      UpdateScheduleView.tag:
          UpdateScheduleView(settings.arguments as Arguments?),
      SelfPostView.tag: const SelfPostView(),
      ManageScheduleView.tag: const ManageScheduleView(),
      MessageBoardView.tag: MessageBoardView(settings.arguments as Arguments?),
      AppointmentDetailView.tag:
          AppointmentDetailView(settings.arguments as Arguments?),
      CallView.tag: CallView(settings.arguments as Arguments?),
    };
