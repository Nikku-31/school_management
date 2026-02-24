import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
  FlutterLocalNotificationsPlugin();

  // 🔔 Dashboard badge ke liye callback
  Function()? onNotificationReceived;

  Future<void> init({Function()? onNotification}) async {

    onNotificationReceived = onNotification;

    // 🔹 Android Initialization
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _local.initialize(settings);

    // 🔹 Permission (Android 13+)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔹 Create Notification Channel (Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _local
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 🔹 Get FCM Token
    String? token = await _messaging.getToken();
    print("=================================");
    print("FCM TOKEN: $token");

    // 🔹 Token Refresh Listener
    _messaging.onTokenRefresh.listen((newToken) {
      print("NEW FCM TOKEN: $newToken");
    });

    // 🔹 Foreground Notification Listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      //  Dashboard badge update
      if (onNotificationReceived != null) {
        onNotificationReceived!();
      }
      if (message.notification != null) {
        showNotification(
          message.notification!.title ?? "",
          message.notification!.body ?? "",
        );
      }
    });
  }

  // 🔔 SHOW NOTIFICATION
  Future<void> showNotification(String title, String body) async {

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique id
      title,
      body,
      details,
    );
  }
}