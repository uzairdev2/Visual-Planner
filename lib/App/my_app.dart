import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/Notifications/Notifications.dart';

import '../Core/controllers/Auth Controllers/auth_controllers.dart';
import '../Core/routes/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
        }
      },
    );

    int a = 0;
    FirebaseMessaging.onMessage.listen(
      (message) async {
        log("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          a++;
          log(a.toString());
          NotificationServices.createanddisplaynotification(message, a);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        log("FirebaseMessaging.onMessageOpenedApp.listen");

        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          log("message.data22 ${message.data['_id']}");
        }
      },
    );

    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Virtual Planner',
        // theme: AppTheme.basic,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.grey,
          useMaterial3: true,
        ),
        initialRoute: Routes.splashScreen,
        getPages: Routes.getPages,
      ),
    );
  }
}
