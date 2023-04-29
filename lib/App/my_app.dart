import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../Core/controllers/Auth Controllers/auth_controllers.dart';
import '../Core/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
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
