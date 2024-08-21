import 'dart:convert';
import 'package:dropill_project/app.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/locator.dart';
import 'package:dropill_project/services/firebase_service.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencies();

  final secureStorage = SecureStorage();

  await Firebase.initializeApp();

  final firebaseMessagingService = FirebaseMessagingService(secureStorage);
  await firebaseMessagingService.initNotifications();

  runApp(const App());
}

/* A configuração manual do Firebase pode ser usada se necessário
const firebaseOptions = FirebaseOptions(
    apiKey: 'AIzaSyBBeQoAVVWtVAbjAlUTQpO3GkaaYnZ6cBU',
    appId: '1:107700309928:android:b02bc68db6a00575d2579d',
    messagingSenderId: '107700309928',
    projectId: 'dropill-a786e',
    storageBucket: 'dropill-a786e.appspot.com',
  );

await Firebase.initializeApp(options: firebaseOptions);
*/
