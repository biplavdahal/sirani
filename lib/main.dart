import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bestfriend/bestfriend.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:mysirani/app.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/di.dart';
import 'package:mysirani/services/heroku_api.service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('channel')) {
    AwesomeNotifications().initialize(
      'resource://drawable/ic_notification_logo', // icon for your app notification
      [
        NotificationChannel(
          channelKey: 'incomingCall',
          channelName: 'Incoming Calls',
          channelDescription:
              "This channel contains all of the notifications related to incoming calls.",
          playSound: true,
          enableLights: true,
          enableVibration: true,
          locked: true,
        ),
      ],
    );

    await AwesomeNotifications().cancelAll();

    FlutterRingtonePlayer.playRingtone();

    Map<String, String> payload = {
      "name": message.data["name"],
      "channel": message.data["channel"],
      "caller_id": message.data["caller_id"],
    };

    if (message.data.containsKey("agora_token")) {
      payload["agora_token"] = message.data["agora_token"];
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'incomingCall',
        title: message.data["name"],
        body: "You have an incoming call. Tap to answer...",
        payload: payload,
      ),
      // actionButtons: [
      //   NotificationActionButton(
      //     enabled: true,
      //     label: "Answer",
      //     key: "Answer",
      //   ),
      // ],
    );

    Timer(const Duration(seconds: 10), () async {
      FlutterRingtonePlayer.stop();
      await AwesomeNotifications().cancelAll();
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'channel2',
          title: "Missed call",
          body: "You missed an appointment call from ${payload["name"]}",
        ),
      );
    });
  }

  if (message.data.containsKey('sender_id')) {
    AwesomeNotifications().initialize(
      'resource://drawable/ic_notification_logo', // icon for your app notification
      [
        NotificationChannel(
          channelKey: 'message',
          channelName: 'Incoming Messages',
          channelDescription:
              "This channel contains all of the notifications related to incoming messages.",
          playSound: true,
          enableLights: true,
          enableVibration: true,
        ),
      ],
    );

    await AwesomeNotifications().cancelAll();

    Map<String, String> payload = {
      "sender_name": message.data["full_name"],
      "sender_id": message.data["sender_id"],
    };

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'message',
        title: message.data["full_name"],
        body: message.notification!.body!,
        payload: payload,
      ),
    );
  }

  debugPrint("Handling a background message: ${message.data}");
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await setupLocator();
  await locator<SharedPreferenceService>()();

  locator<ApiService>()(
    baseUrl: auBaseUrl,
  );

  locator<HerokuApiService>()(
    baseUrl: auHerokuUrl,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MySiraniApp());
  });
}
