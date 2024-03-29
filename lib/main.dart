import 'package:device_preview/device_preview.dart';
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
    DevicePreview(
      enabled: false,
      builder: (context) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static GlobalKey uiamKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: uiamKey,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: lightAppTheme,
      darkTheme: darkAppTheme,
      themeMode: ThemeMode.light,
      title: appName,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> initServices() async {
  await Get.putAsync<AuthService>(() async => await AuthService());
}
