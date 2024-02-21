import 'package:bestfriend/bestfriend.dart';
import 'package:esewa_pnp/esewa.dart';
import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:mysirani/config.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.service.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.service.impl.dart';
import 'package:mysirani/managers/dialog/dialog.service.dart';
import 'package:mysirani/managers/dialog/dialog.service.impl.dart';
import 'package:mysirani/services/app.service.dart';
import 'package:mysirani/services/app_data.service.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/call.service.dart';
import 'package:mysirani/services/chat.service.dart';
import 'package:mysirani/services/counsellor.service.dart';
import 'package:mysirani/services/forum.service.dart';
import 'package:mysirani/services/heroku_api.service.dart';
import 'package:mysirani/services/implementations/app.service.impl.dart';
import 'package:mysirani/services/implementations/app_data.service.impl.dart';
import 'package:mysirani/services/implementations/appointment.service.impl.dart';
import 'package:mysirani/services/implementations/authentication.service.impl.dart';
import 'package:mysirani/services/implementations/call.service.impl.dart';
import 'package:mysirani/services/implementations/chat.sevice.impl.dart';
import 'package:mysirani/services/implementations/counsellor.service.impl.dart';
import 'package:mysirani/services/implementations/forum.service.impl.dart';
import 'package:mysirani/services/implementations/notification.service.impl.dart';
import 'package:mysirani/services/implementations/program.service.impl.dart';
import 'package:mysirani/services/implementations/resource.service.impl.dart';
import 'package:mysirani/services/implementations/user.service.impl.dart';
import 'package:mysirani/services/implementations/wallet.service.impl.dart';
import 'package:mysirani/services/notification.service.dart';
import 'package:mysirani/services/program.service.dart';
import 'package:mysirani/services/resource.service.dart';
import 'package:mysirani/services/user.service.dart';
import 'package:mysirani/services/wallet.service.dart';
import 'package:mysirani/views/authentication/authentication.model.dart';
import 'package:mysirani/views/call/call.model.dart';
import 'package:mysirani/views/change_password/change_password.model.dart';
import 'package:mysirani/views/chat_plans/chat_plans.model.dart';
import 'package:mysirani/views/chats_list/chat_list.model.dart';
import 'package:mysirani/views/counsellor_profile/counsellor_profile.model.dart';
import 'package:mysirani/views/create_appointment/create_appointment.model.dart';
import 'package:mysirani/views/dashboard/dashboard.model.dart';
import 'package:mysirani/views/dashboard/fragments/appointments/appointments.model.dart';
import 'package:mysirani/views/dashboard/fragments/counsellors/counsellors.model.dart';
import 'package:mysirani/views/dashboard/fragments/home/home.model.dart';
import 'package:mysirani/views/dashboard/fragments/profile/profile.model.dart';
import 'package:mysirani/views/dashboard/fragments/resources/resources.model.dart';
import 'package:mysirani/views/edit_profile/edit_profile.model.dart';
import 'package:mysirani/views/forum/forum.model.dart';
import 'package:mysirani/views/free_sessions/free_sessions.model.dart';
import 'package:mysirani/views/load_fund/load_fund.model.dart';
import 'package:mysirani/views/manage_schedule/manage_schedule.model.dart';
import 'package:mysirani/views/message_board/message_board.model.dart';
import 'package:mysirani/views/notification/notification.model.dart';
import 'package:mysirani/views/onboarding/onboarding.model.dart';
import 'package:mysirani/views/ms_page/ms_page.model.dart';
import 'package:mysirani/views/programs/programs.model.dart';
import 'package:mysirani/views/resource/resource.model.dart';
import 'package:mysirani/views/resource_list/resource_list.model.dart';
import 'package:mysirani/views/self_post/self_post.model.dart';
import 'package:mysirani/views/start_up/start_up.model.dart';
import 'package:mysirani/views/statement/statement.model.dart';
import 'package:mysirani/views/survey/survey.model.dart';
import 'package:mysirani/views/update_schedule/update_schedule.model.dart';
import 'package:mysirani/views/user_pacakge/user_package.model.dart';
import 'package:mysirani/views/user_profile/user_profile.model.dart';
import 'package:mysirani/views/view_survey/view_survey.model.dart';
import 'package:mysirani/views/write_thread/write_thread.model.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> setupLocator() async {
  // Register external dependencies
  PackageInfo _packageInfo = await PackageInfo.fromPlatform();

  locator.registerLazySingleton(() => _packageInfo);

  ESewaConfiguration _configuration = ESewaConfiguration(
    clientID: cnEsewaClientID,
    secretKey: cnEsewaSecretKey,
    environment: cnEsewaEnvironment,
  );

  ESewaPnp _eSewaPnp = ESewaPnp(configuration: _configuration);

  locator.registerLazySingleton(() => _eSewaPnp);

  // Register services
  locator.registerLazySingleton<AppService>(() => AppServiceImplementation());

  locator.registerLazySingleton<ApiService>(() => ApiServiceImplementation());

  locator.registerLazySingleton(() => HerokuApiService());

  locator.registerLazySingleton<CallService>(() => CallServiceImplementation());

  locator.registerLazySingleton<ChatService<ApiService>>(
      () => ChatServiceImplementation<ApiService>());

  locator.registerLazySingleton<ProgramService>(
      () => ProgramServiceImplementation());

  locator.registerLazySingleton<NotificationService>(
      () => NotificationServiceImplementation());

  locator.registerLazySingleton<AppointmentService>(
      () => AppointmentServiceImplementation());

  locator.registerLazySingleton<ResourceService>(
      () => ResourceServiceImplementation());

  locator.registerLazySingleton<WalletService>(
      () => WalletServiceImplementation());

  locator.registerLazySingleton<CounsellorService>(
      () => CounsellorServiceImplementation());

  locator.registerLazySingleton<UserService>(() => UserServiceImplementation());

  locator.registerLazySingleton<BottomSheetService>(
      () => BottomSheetServiceImplementation());

  locator
      .registerLazySingleton<ForumService>(() => ForumServiceImplementation());

  locator.registerLazySingleton<DialogService>(
      () => DialogServiceImplementation());

  locator.registerLazySingleton<AuthenticationService>(
      () => AuthenticationServiceImplementation());

  locator.registerLazySingleton<NavigationService>(
      () => NavigationServiceImplementation());

  locator.registerLazySingleton<SnackbarService>(
      () => SnackbarServiceImplementation());

  locator.registerLazySingleton<SharedPreferenceService>(
      () => SharedPreferenceServiceImplementation());

  locator.registerLazySingleton<AppDataService>(
      () => AppDataServiceImplementation());

  // Register unkillable view models
  //...
  locator.registerLazySingleton(() => ProgramsModel());

  locator.registerLazySingleton(() => ProfileModel());

  locator.registerLazySingleton(() => ResoucesModel());

  locator.registerLazySingleton(() => AppointmentsModel());

  locator.registerLazySingleton(() => CounsellorsModel());

  locator.registerLazySingleton(() => HomeModel());

  locator.registerLazySingleton(() => ManageScheduleModel());

  locator.registerLazySingleton(() => FreeSessionsModel());

  locator.registerLazySingleton(() => ChatsListModel());

  // Register killable view models
  locator.registerFactory(() => MessageBoardModel());

  locator.registerFactory(() => UpdateScheduleModel());

  locator.registerFactory(() => SelfPostModel());

  locator.registerFactory(() => MSPageModel());

  locator.registerFactory(() => NotificationModel());

  locator.registerFactory(() => CreateAppointmentModel());

  locator.registerFactory(() => SurveyModel());

  locator.registerFactory(() => ViewSurveyModel());

  locator.registerFactory(() => ResourceListModel());

  locator.registerFactory(() => ResourceModel());

  locator.registerFactory(() => LoadFundModel());

  locator.registerFactory(() => EditProfileModel());

  locator.registerFactory(() => ChatPlansModel());

  locator.registerFactory(() => UserPackageModel());

  locator.registerFactory(() => StatementModel());

  locator.registerFactory(() => ChangePasswordModel());

  locator.registerFactory(() => UserProfileModel());

  locator.registerFactory(() => CounsellorProfileModel());

  locator.registerFactory(() => WriteThreadModel());

  locator.registerFactory(() => ForumModel());

  locator.registerFactory(() => DashboardModel());

  locator.registerFactory(() => AuthenticationModel());

  locator.registerFactory(() => OnboardingModel());

  locator.registerFactory(() => StartUpModel());

  locator.registerFactory(() => CallModel());
}
