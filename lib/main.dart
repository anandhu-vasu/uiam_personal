import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uiam_personal/app/services/auth_service.dart';

import 'app/routes/app_pages.dart';
import 'core/theme/dark_app_theme.dart';
import 'core/theme/light_app_theme.dart';
import 'core/values/strings.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initServices();
  runApp(
    GetMaterialApp(
      theme: lightAppTheme,
      darkTheme: darkAppTheme,
      title: appName,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      themeMode: ThemeMode.light,
    ),
  );
}

Future<void> initServices() async {
  await Get.putAsync<AuthService>(() async => await AuthService());
}
