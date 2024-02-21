import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationService {
  /// Initializes local notification channels
  void initializeLocalNotification();

  /// Get permission [Apple/Web]
  Future<bool> getPermission();

  /// Update FCM Token into user's firestore document.
  Future<void> updateFcmToken(String accessToken, int userId);

  /// Listen to foreground notification
  Stream<RemoteMessage> onNotificationArrive();

  /// Listens to notification that was clicked to open app
  Stream<RemoteMessage> onMessageOpenedApp();

  /// Gets initial notification
  Future<RemoteMessage?> getInitialMessage();

  /// Notify locally
  Future<void> showNotification(
      {required String title, required String body, String? payload});

  /// Show call notification
  Future<void> showCallNotification({
    required String caller,
    required Map<String, String> payload,
  });

  // Show message notification
  Future<void> showMessageNotification({
    required String senderName,
    required Map<String, dynamic> payload,
  });

  /// Cancel all notifications
  Future<void> cancelNotification([String? key]);
}
