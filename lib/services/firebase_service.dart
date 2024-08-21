import 'dart:convert';
import 'package:dropill_project/app.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final SecureStorage _secureStorage;

  FirebaseMessagingService(this._secureStorage);

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      message.messageId.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: json.encode(message.data),
    );
  }

  void handleMessage(RemoteMessage message) {
    if (message != null) {
      _showLocalNotification(message);
    }
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _navigateToConfirmationScreen(message.data);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigateToConfirmationScreen(message.data);
    });
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    if (fCMToken != null) {
      await _secureStorage.write(key: 'fcmToken', value: fCMToken);
      print('Token FCM obtido: $fCMToken');
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    initPushNotifications();
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      final data = json.decode(response.payload!) as Map<String, dynamic>;
      _navigateToConfirmationScreen(data);
    }
  }

  void _navigateToConfirmationScreen(Map<String, dynamic> data) {
    navigatorKey.currentState?.pushNamed(
      NamedRoute.confirmation,
      arguments: data,
    );
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}
