import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bestfriend/bestfriend.dart';
import 'package:dio/dio.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/notification.service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServiceImplementation implements NotificationService {
  // External depedencies
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Services
  final ApiService _apiService = locator<ApiService>();

  @override
  Future<bool> getPermission() async {
    if (Platform.isIOS) {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      return (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional);
    }

    bool localNotificationAllowed =
        await AwesomeNotifications().isNotificationAllowed();

    if (!localNotificationAllowed) {
      localNotificationAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    return localNotificationAllowed;
  }

  @override
  Future<void> updateFcmToken(String accessToken, int uid) async {
    try {
      final token = await _firebaseMessaging.getToken();
      final response = await _apiService.post(
        auFCMNotificationPost,
        {
          "access_token": accessToken,
          "type": Platform.isIOS ? "Ios" : "Android",
          "token": token,
          "user_id": uid
        },
      );

      final data = constructResponse(response.data);

      if (data!["status"] == "failure") {
        throw ErrorData.fromJson(data);
      }
    } on DioError catch (e) {
      throw dioError(e);
    }
  }

  @override
  Future<RemoteMessage?> getInitialMessage() {
    return _firebaseMessaging.getInitialMessage();
  }

  @override
  void initializeLocalNotification() async {
    AwesomeNotifications().initialize(
      'resource://drawable/ic_notification_logo', // icon for your app notification
      [
        NotificationChannel(
          channelKey: 'channel1',
          channelName: 'My Sirani',
          channelDescription:
              "This channel contains all of the foreground notifications.",
          playSound: true,
          enableLights: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: 'channel2',
          channelName: 'My Sirani',
          channelDescription:
              "This channel contains all of the non-critical foreground notifications.",
          playSound: true,
          enableLights: true,
          enableVibration: true,
        ),
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
        NotificationChannel(
          channelKey: 'message',
          channelName: 'Messages',
          channelDescription:
              "This channel contains all of the notifications related to incoming messages.",
          playSound: true,
          enableLights: true,
          enableVibration: true,
          locked: false,
        ),
      ],
    );
  }

  @override
  Stream<RemoteMessage> onMessageOpenedApp() {
    return FirebaseMessaging.onMessageOpenedApp;
  }

  @override
  Stream<RemoteMessage> onNotificationArrive() {
    return FirebaseMessaging.onMessage;
  }

  @override
  Future<void> showNotification(
      {required String title, required String body, String? payload}) async {
    if (payload != null) {
      final notification = jsonDecode(payload) as Map<String, dynamic>;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'channel1',
          title: notification["title"],
          body: notification["body"],
          bigPicture:
              notification.containsKey("image") ? notification["image"] : null,
        ),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'channel2',
          title: title,
          body: body,
        ),
      );
    }
  }

  @override
  Future<void> showCallNotification({
    required String caller,
    required Map<String, String> payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'incomingCall',
        title: caller,
        body: "You have an incoming call",
        payload: payload,
      ),
      actionButtons: [
        NotificationActionButton(
          enabled: true,
          label: "Answer",
          key: "Answer",
        ),
      ],
    );
  }

  @override
  Future<void> showMessageNotification({
    required String senderName,
    required Map<String, dynamic> payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'message',
        title: senderName,
        body: payload["message"],
        payload: {
          "sender_id": payload["sender_id"],
          "sender_name": payload["full_name"],
        },
      ),
    );
  }

  @override
  Future<void> cancelNotification([String? key]) async {
    await AwesomeNotifications().cancelAll();
  }
}
