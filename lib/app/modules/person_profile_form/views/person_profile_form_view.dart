import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';
import 'package:uiam_personal/app/data/enums/variant_button_size.dart';
import 'package:uiam_personal/app/global/widgets/drop_shadow.dart';
import 'package:uiam_personal/app/global/widgets/variant_button.dart';
import 'package:uiam_personal/app/global/widgets/variant_progress_button.dart';
import 'package:uiam_personal/app/routes/app_pages.dart';
import 'package:uiam_personal/core/theme/variant_theme.dart';
import 'package:uiam_personal/core/values/consts.dart';

import '../../../global/animations/fade_in_animation.dart';
import '../../../uiamblockchain/uiam_blockchain_connection.dart';
import '../controllers/person_profile_form_controller.dart';

class PersonProfileFormView
    extends GetResponsiveView<PersonProfileFormController> {
  PersonProfileFormView({Key? key})
      : super(
          key: key,
        );

  @override
  Widget builder() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 20,
          elevation: 0,
          bottom: TabBar(
              controller: controller.tabController,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              indicatorSize: TabBarIndicatorSize.tab,
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return states.contains(MaterialState.focused)
                      ? null
                      : Colors.transparent;
                },
              ),
              indicatorColor: Get.theme.colorScheme.onPrimary.withOpacity(0.8),
              unselectedLabelColor:
                  Get.theme.colorScheme.onBackground.withOpacity(0.7),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: VariantTheme.primary.color,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Get.theme.shadowColor.withOpacity(0.5),
                    blurRadius: 99,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                      color: VariantTheme.primary.shadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 2))
                ],
              ),
              tabs: [
                const Tab(
                  text: 'Info',
                ),
                const Tab(
                  text: 'Address',
                ),
              ]),
        ),
        body: TabBarView(controller: controller.tabController, children: [
          Form(
            key: controller.infoFormKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: dSpace),
                  GestureDetector(
                    onTap: () async {
                      await controller.selectImage(ImageSource.gallery);
                    },
                    child: DropShadow(
                      shadowOpacity: 0.5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(children: [
                          Obx(() => Center(
                              child: controller.imagePath.value.isEmpty
                                  ? Icon(Icons.person_add,
                                      size: 50,
                                      color: Get.theme.colorScheme.onBackground
                                          .withOpacity(0.7))
                                  : Obx(() => OctoImage(
                                      image: CachedNetworkImageProvider(
                                          controller.imagePath.value),
                                      progressIndicatorBuilder:
                                          OctoProgressIndicator
                                              .circularProgressIndicator())))),
                          Obx(() => controller
                                  .storageController.isUploading.value
                              ? FadeInAnimation(
                                  child: Center(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaY: 7, sigmaX: 7),
                                      child:
                                          Obx(() => CircularProgressIndicator(
                                                value: controller
                                                    .storageController
                                                    .uploadPercent
                                                    .value,
                                              )),
                                    ),
                                  ),
                                )
                              : Container())
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: dSpace),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: dSpace,
                    runSpacing: dSpace,
                    children: [
                      DropShadow(
                        child: FocusScope(
                          onFocusChange: (hasFocus) {
                            if (!hasFocus &&
                                controller.imagePath.value.isEmpty) {
                              controller.person.copyWith();
                            }
                          },
                          child: TextFormField(
                            initialValue: controller.person.name,
                            onSaved: (value) => controller.person =
                                controller.person.copyWith(name: value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: "Name"),
                          ),
                        ),
                      ),
                      DropShadow(
                        child: TextFormField(
                          initialValue: controller.person.email,
                          onSaved: (value) => controller.person =
                              controller.person.copyWith(email: value),
                          validator: (value) {
                            if (GetUtils.isNullOrBlank(value)!) {
                              return 'Please enter your email';
                            } else if (!GetUtils.isEmail(value!)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: "Email"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: dSpace),
                  DropShadow(
                    child: DateTimePicker(
                      initialValue: controller.person.dateOfBirth?.toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date of Birth',
                      validator: (value) {
                        if (GetUtils.isNullOrBlank(value)!) {
                          return 'Please enter your date of birth';
                        }
                        return null;
                      },
                      onSaved: (value) => controller.person = controller.person
                          .copyWith(
                              dateOfBirth: GetUtils.isNullOrBlank(value)!
                                  ? null
                                  : DateTime.parse(value!)),
                    ),
                  ),
                  const SizedBox(height: dSpace),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VariantProgressButton(
                        size: VariantButtonSize.xlarge,
                        width: hSize,
                        content: controller.person.id != null ? "Save" : "Next",
                        onCompleted: () {
                          if (controller.person.id != null) {
                            Map<String, dynamic>? arguments = Get.arguments;
                            Get.toNamed(arguments?['next'] ?? Routes.HOME);
                          }
                        },
                        onTap: () async {
                          if (controller.infoFormKey.currentState != null &&
                              controller.infoFormKey.currentState!.validate()) {
                            controller.infoFormKey.currentState!.save();
                            if (controller.imagePath.isEmpty) {
                              controller.imagePath.value =
                                  "https://ui-avatars.com/api/?name=${controller.person.name}&size=128";
                            }
                            controller.person = controller.person
                                .copyWith(image: controller.imagePath.value);

                            controller.isInfoSave = true;

                            if (controller.person.id != null) {
                              final ret = await controller.personProvider
                                  .save(model: controller.person);
                              controller.auth.user = controller.person;

                              if(controller.success){
                                var uidHash = controller.auth.user.id!+controller.hashingvalue;

                                  var bytes = utf8.encode(uidHash);

                                  var digest = sha256.convert(bytes); //data converted to sh256
                                  UiamModel().addUser(controller.auth.user.id, digest.toString());
                              }
                              
                              return ret;
                            } else {
                              controller.tabController.animateTo(1);
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: dSpace),
                ]),
              ),
            ),
          ),
          Form(
            key: controller.addressFormKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: dSpace),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: dSpace,
                    spacing: dSpace,
                    children: [
                      DropShadow(
                        child: TextFormField(
                          initialValue: controller.person.address,
                          onSaved: (value) => controller.person =
                              controller.person.copyWith(address: value),
                          validator: (value) {
                            if (GetUtils.isNullOrBlank(value)!) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Address",
                          ),
                        ),
                      ),
                      DropShadow(
                        child: TextFormField(
                          initialValue: controller.person.place,
                          onSaved: (value) => controller.person =
                              controller.person.copyWith(place: value),
                          validator: (value) {
                            if (GetUtils.isNullOrBlank(value)!) {
                              return 'Please enter your place';
                            }
                            return null;
                          },
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Place",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: dSpace),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: dSpace,
                    spacing: dSpace,
                    children: [
                      DropShadow(
                        child: TextFormField(
                          initialValue: controller.person.city,
                          onSaved: (value) => controller.person =
                              controller.person.copyWith(city: value),
                          validator: (value) {
                            if (GetUtils.isNullOrBlank(value)!) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "City",
                          ),
                        ),
                      ),
                      DropShadow(
                        child: TextFormField(
                          initialValue: controller.person.state,
                          onSaved: (value) => controller.person =
                              controller.person.copyWith(state: value),
                          validator: (value) {
                            if (GetUtils.isNullOrBlank(value)!) {
                              return 'Please enter your state';
                            }
                            return null;
                          },
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "State",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: dSpace),
                  DropShadow(
                    child: TextFormField(
                      initialValue: controller.person.postalCode,
                      onSaved: (value) => controller.person =
                          controller.person.copyWith(postalCode: value),
                      validator: (value) {
                        if (GetUtils.isNullOrBlank(value)!) {
                          return 'Please enter your postal code';
                        } else if (int.tryParse(value!) == null ||
                            value.length != 6) {
                          return 'Please enter 6 digit postal code';
                        }
                        return null;
                      },
                      minLines: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Postal Code",
                      ),
                    ),
                  ),
                  const SizedBox(height: dSpace),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VariantProgressButton(
                        size: VariantButtonSize.xlarge,
                        width: hSize,
                        content: "Save",
                        onCompleted: () {
                          Map<String, dynamic>? arguments = Get.arguments;
                          Get.toNamed(arguments?['next'] ?? Routes.HOME);
                        },
                        onTap: () async {
                          if (controller.addressFormKey.currentState != null &&
                              controller.addressFormKey.currentState!
                                  .validate()) {
                            if (controller.infoFormKey.currentState != null &&
                                !controller.infoFormKey.currentState!
                                    .validate()) {
                              controller.tabController.animateTo(0);
                              return null;
                            }

                            if (!controller.isInfoSave) {
                              controller.infoFormKey.currentState!.save();
                              if (controller.imagePath.isEmpty) {
                                controller.imagePath.value =
                                    "https://ui-avatars.com/api/?name=${controller.person.name}&size=128";
                              }
                              controller.person = controller.person
                                  .copyWith(image: controller.imagePath.value);
                            }

                            controller.addressFormKey.currentState!.save();

                            final ret = await controller.personProvider
                                .save(model: controller.person);
                            controller.auth.user = controller.person;

                            if(controller.success){
                              var uidHash = controller.auth.user.id!+controller.hashingvalue;

                                var bytes = utf8.encode(uidHash);

                                var digest = sha256.convert(bytes); //data converted to sh256
                                UiamModel().addUser(controller.auth.user.id, digest.toString());
                            }

                            

                            return ret;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: dSpace),
                ]),
              ),
            ),
          ),
        ]));
  }
}
