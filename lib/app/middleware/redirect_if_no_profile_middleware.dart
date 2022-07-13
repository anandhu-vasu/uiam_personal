import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uiam_personal/app/routes/app_pages.dart';

import '../services/auth_service.dart';

class RedirectIfNoProfile extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return Get.find<AuthService>().user.id == null
        ? RouteSettings(
            name: Routes.PERSON_PROFILE_FORM, arguments: {"next": route})
        : null;
  }
}
