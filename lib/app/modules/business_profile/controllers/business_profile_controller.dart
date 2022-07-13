import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:uiam_personal/app/services/auth_service.dart';

class BusinessProfileController extends GetxController {
  final auth = Get.find<AuthService>();
  final bid = Get.parameters['bid'];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
