import 'package:get/get.dart';

import '../middleware/auth_middleware.dart';
import '../middleware/redirect_if_auth_middleware.dart';
import '../middleware/redirect_if_no_profile_middleware.dart';
import '../modules/appointments/bindings/appointments_binding.dart';
import '../modules/appointments/views/appointments_view.dart';
import '../modules/business_profile/bindings/business_profile_binding.dart';
import '../modules/business_profile/views/business_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/person_profile_form/bindings/person_profile_form_binding.dart';
import '../modules/person_profile_form/views/person_profile_form_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        middlewares: [AuthMiddleware(), RedirectIfNoProfile()]),
    GetPage(
        name: _Paths.LOGIN,
        page: () => const LoginView(),
        binding: LoginBinding(),
        middlewares: [RedirectIfAuth()]),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),

      // children: [
      //   GetPage(
      //     name: _Paths.HOME,
      //     page: () => HomeView(),
      //     binding: HomeBinding(),
      //   ),
      // ],
    ),
    GetPage(
      name: _Paths.PERSON_PROFILE_FORM,
      page: () => PersonProfileFormView(),
      binding: PersonProfileFormBinding(),
    ),
    GetPage(
      name: _Paths.BUSINESS_PROFILE,
      page: () => BusinessProfileView(),
      binding: BusinessProfileBinding(),
    ),
    GetPage(
      name: _Paths.APPOINTMENTS,
      page: () => AppointmentsView(),
      binding: AppointmentsBinding(),
    ),
  ];
}
