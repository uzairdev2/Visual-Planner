import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:visual_planner/App/my_app.dart';

Future<void> backgroundHandler(RemoteMessage message) async {}

// NotificationServices LocalNotificationService = NotificationServices();

void main() async {
  // Initialize Firebase
  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // NotificationServices.initialize();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true, 
    sound: true,
  );

  // Run the app
  runApp(const MyApp());
}
