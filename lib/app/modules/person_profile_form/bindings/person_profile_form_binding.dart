import 'package:get/get.dart';
import 'package:uiam_personal/app/controllers/firebase_storage_controller.dart';

import '../controllers/person_profile_form_controller.dart';

class PersonProfileFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonProfileFormController>(
      () => PersonProfileFormController(),
    );

    Get.lazyPut<FirebaseStorageController>(() => FirebaseStorageController());
  }
}
