import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uiam_personal/app/services/auth_service.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final auth = Get.find<AuthService>();
  //final searchController = TextEditingController();
  final search = ''.obs;
  final type = Rxn<String>(null);

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
