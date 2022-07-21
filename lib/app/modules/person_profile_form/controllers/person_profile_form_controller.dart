import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uiam_personal/app/services/auth_service.dart';
import '../../../utils/helpers/cropper/ui_helper.dart'
    if (dart.library.io) '../../../utils/helpers/cropper/mobile_ui_helper.dart'
    if (dart.library.html) '../../../utils/helpers/cropper/web_ui_helper.dart';
import '../../../controllers/firebase_storage_controller.dart';
import '../../../data/models/person_model.dart';
import '../../../data/providers/person_provider.dart';

class PersonProfileFormController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GlobalKey<FormState> infoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  late final tabController = TabController(length: 2, vsync: this);

  final hashingvalue = "qwertyuiopasdfghjklzxcvbnm";
  bool success = false;

  final AuthService auth = Get.find<AuthService>();

  PersonModel person = PersonModel();
  late PersonProvider personProvider;

  final imagePath = ''.obs;

  bool isInfoSave = false;

  final storageController = Get.find<FirebaseStorageController>();

  @override
  void onInit() {
    personProvider = PersonProvider(auth.uid);
    person = auth.user;
    person.copyWith(id: auth.uid);
    if (auth.user.phone == null) {
      person = person.copyWith(phone: auth.firebaseUser!.phoneNumber);
    }
    imagePath.value = person.image ?? '';
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<CroppedFile?> cropImage(String path) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 128,
      maxWidth: 128,
      cropStyle: CropStyle.rectangle,
      uiSettings: buildUiSettings(Get.context!),
    );

    return croppedImage;
  }

  Future<void> selectImage(ImageSource source) async {
    final _pickedImage =
        await ImagePicker().pickImage(source: source, imageQuality: 75);

    if (_pickedImage != null) {
      CroppedFile? croppedFile = await cropImage(_pickedImage.path);

      if (croppedFile != null) {
        imagePath.value = croppedFile.path;
        storageController.upload("images/${auth.uid}/avatar", croppedFile,
            mimeType: _pickedImage.mimeType, onComplete: (url) {
          imagePath.value = url;
        });
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
