import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marketplace/core/utils/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/network/network_dependency.dart';
import 'core/routing/route_configuration.dart';
import 'core/routing/route_names.dart';
import 'core/theme/themes.dart';
import 'core/utils/app_constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationServices().initNotifications();

  sharedPreferences = await SharedPreferences.getInstance();
  firebaseAuth = FirebaseAuth.instance;

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  runApp(
    const MarketplaceApp(),
  );
  NetWorkDependencyInjection.init();
}

SharedPreferences? sharedPreferences;
FirebaseAuth? firebaseAuth;

class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants().appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      getPages: AppRoutesConfiguration.myRoutes,
      initialRoute: sharedPreferences!.getBool("skipIntro") != true
          ? AppRouteNames.introduction
          : AppRouteNames.login,
    );
  }
}
