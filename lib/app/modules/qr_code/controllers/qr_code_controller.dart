import 'package:get/get.dart';
import 'package:uiam_personal/app/services/auth_service.dart';

class QrCodeController extends GetxController {
  //TODO: Implement QrCodeController

  final count = 0.obs;
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

  void increment() => count.value++;

  final auth=Get.find<AuthService>();
}
