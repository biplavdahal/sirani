import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/managers/bottom_sheet/bottom_sheet.manager.dart';
import 'package:mysirani/managers/dialog/dialog.manager.dart';
import 'package:mysirani/routes.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/start_up/start_up.view.dart';
import 'package:path/path.dart';

class MySiraniApp extends StatelessWidget {
  const MySiraniApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (Context, Widget) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getThemeDataTheme(context),
        onGenerateRoute: (settings) =>
            locator<NavigationService>().generateRoute(
          settings,
          routesAndViews(settings),
        ),
        navigatorKey: locator<NavigationService>().navigationKey,
        builder: (context, child) {
          updateStatusBarColor(AppColor.primary);

          return Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => BottomSheetManager(
                body: DialogManager(
                  child: SnackbarManager(
                    behavior: SnackBarBehavior.floating,
                    elevation: 0,
                    infoColor: AppColor.primary,
                    errorColor: Colors.red,
                    successColor: Colors.green,
                    warningColor: AppColor.accent,
                    body: child!,
                  ),
                ),
              ),
            ),
          );
        },
        home: const StartUpView(),
      ),
    );
  }
}
