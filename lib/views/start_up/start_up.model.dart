import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/app_data.service.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/services/call.service.dart';
import 'package:mysirani/services/notification.service.dart';
import 'package:mysirani/views/authentication/authentication.view.dart';
import 'package:mysirani/views/call/call.argument.dart';
import 'package:mysirani/views/call/call.view.dart';
import 'package:mysirani/views/dashboard/dashboard.view.dart';
import 'package:mysirani/views/message_board/message_board.argument.dart';
import 'package:mysirani/views/message_board/message_board.view.dart';
import 'package:mysirani/views/notification/notification.view.dart';
import 'package:mysirani/views/onboarding/onboarding.view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vibration/vibration.dart';

class StartUpModel extends ViewModel with SnackbarMixin, DialogMixin {
  // Services
  final AppDataService _appDataService = locator<AppDataService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NotificationService _notificationService =
      locator<NotificationService>();
  final CallService _callService = locator<CallService>();
  final AppointmentService _appointmentService = locator<AppointmentService>();

  // Data
  PackageInfo get packageInfo => locator<PackageInfo>();

  // Actions
  Future<void> init(BuildContext context) async {
    final onboardingSeen = await _appDataService.onboardingSeenAlready();

    if (onboardingSeen == null || !onboardingSeen) {
      gotoAndClear(OnboardingView.tag);
    } else {
      final isSignnedIn = await _authenticationService.isSignnedIn();
      if (isSignnedIn) {
        final notificationPermission =
            await _notificationService.getPermission();

        if (!notificationPermission) {
          snackbar.displaySnackbar(
            SnackbarRequest.of(
              message: "You won't receive any notifications.",
              action: SnackbarAction(
                label: "Grant Permission",
                onPressed: _notificationService.getPermission,
              ),
            ),
          );
        }

        _notificationService.initializeLocalNotification();

        final initialMessage = await _notificationService.getInitialMessage();

        AwesomeNotifications().actionStream.listen((notification) async {
          _notificationService.cancelNotification();
          if (notification.channelKey == "incomingCall") {
            await FlutterRingtonePlayer.stop();
            if (notification.buttonKeyPressed == "Answer") {
              if (!notification.payload!.containsKey("agora_token")) {
                final remainingTime =
                    await _appointmentService.getSessionRemainigDuration(
                        int.parse(notification.payload!["caller_id"]!));

                goto(
                  CallView.tag,
                  arguments: CallArgument(
                    notification.payload!["agora_token"]!,
                    notification.payload!["channel"]!,
                    secondPartyName: notification.payload!["name"]!,
                    callerId: int.parse(notification.payload!["caller_id"]!),
                    remainingDuration: remainingTime,
                  ),
                );
              } else {
                dialog.showDialog(
                  DialogRequest(
                      type: DialogType.progressDialog, title: "Joining..."),
                );
                final token = await _callService
                    .getCallToken(notification.payload!["channel"]);
                final remainingTime =
                    await _appointmentService.getSessionRemainigDuration(
                        int.parse(notification.payload!["caller_id"]!));
                dialog.hideDialog();

                goto(
                  CallView.tag,
                  arguments: CallArgument(
                    token,
                    notification.payload!["channel"]!,
                    secondPartyName: notification.payload!["name"]!,
                    callerId: int.parse(notification.payload!["caller_id"]!),
                    remainingDuration: remainingTime,
                  ),
                );
              }
            } else {
              _actionOnIncomingCall(notification.payload!);
            }
          } else if (notification.channelKey == "message") {
            goto(MessageBoardView.tag,
                arguments: MessageBoardArgument(
                  receiverId: int.parse(notification.payload!["sender_id"]!),
                  receiverName: notification.payload!["sender_name"]!,
                ));
          }
        });

        _notificationService.onNotificationArrive().listen((message) async {
          final _notificationData = message.data;

          debugPrint(_notificationData.toString());

          if (_notificationData.containsKey("channel")) {
            _actionOnIncomingCall(_notificationData);
          } else if (_notificationData.containsKey("sender_id")) {
            String? currentPath;
            locator<NavigationService>()
                .navigationKey
                .currentState
                ?.popUntil((route) {
              currentPath = route.settings.name;
              return true;
            });
            if (currentPath == MessageBoardView.tag) {
              return;
            }

            snackbar.displaySnackbar(SnackbarRequest.of(
              message:
                  "You have a new message from ${_notificationData["full_name"]}",
              duration: ESnackbarDuration.long,
              action: SnackbarAction(
                  label: "Open",
                  onPressed: () {
                    goto(
                      MessageBoardView.tag,
                      arguments: MessageBoardArgument(
                        receiverId: int.parse(_notificationData["sender_id"]!),
                        receiverName: _notificationData["full_name"]!,
                      ),
                    );
                  }),
            ));
          } else {
            _notificationService.showNotification(
              title: _notificationData["title"],
              body: _notificationData["body"],
              payload: jsonEncode(message.data),
            );
          }
        });

        _notificationService.onMessageOpenedApp().listen((message) {
          debugPrint(message.data.toString());
        });

        if (initialMessage != null) {
          debugPrint(initialMessage.data.toString());
          goto(NotificationView.tag);
        }

        gotoAndClear(DashboardView.tag);
      } else {
        gotoAndClear(AuthenticationView.tag);
      }
    }
  }

  Future<void> _actionOnIncomingCall(
      Map<String, dynamic> _notificationData) async {
    if (_notificationData.containsKey("agora_token")) {
      Vibration.vibrate(duration: 1000);
      FlutterRingtonePlayer.playRingtone();

      Timer _timer = Timer(const Duration(seconds: 10), () {
        dialog.hideDialog();
        FlutterRingtonePlayer.stop();
        Vibration.vibrate(duration: 1000);

        _notificationService.showNotification(
          title: "Missed call",
          body:
              "You missed an appointment call from ${_notificationData["name"]}",
        );
      });

      final remainigDuration =
          await _appointmentService.getSessionRemainigDuration(
              int.parse(_notificationData["caller_id"]));

      dialog.showDialog(
        DialogRequest(
            type: DialogType.incomingCall,
            title: "Incoming Call",
            payload: {
              "timer": _timer,
              "caller": _notificationData["name"],
              "token": _notificationData["agora_token"],
              "channel": _notificationData["channel"],
              "caller_id": _notificationData["caller_id"],
              "remaining_duration": remainigDuration,
            }),
      );
    } else {
      // Request agora token
      final token =
          await _callService.getCallToken(_notificationData["channel"]);
      Vibration.vibrate(duration: 1000);

      FlutterRingtonePlayer.playRingtone();
      Timer _timer = Timer(const Duration(seconds: 10), () {
        dialog.hideDialog();
        FlutterRingtonePlayer.stop();
        _notificationService.showNotification(
          title: "Missed call",
          body:
              "You missed an appointment call from ${_notificationData["name"]}",
        );
      });
      final remainigDuration =
          await _appointmentService.getSessionRemainigDuration(
              int.parse(_notificationData["caller_id"]));

      dialog.showDialog(
        DialogRequest(
            type: DialogType.incomingCall,
            title: "Incoming Call",
            payload: {
              "timer": _timer,
              "caller": _notificationData["name"],
              "token": token,
              "channel": _notificationData["channel"],
              "caller_id": _notificationData["caller_id"],
              "remaining_duration": remainigDuration,
            }),
      );
    }
  }
}
