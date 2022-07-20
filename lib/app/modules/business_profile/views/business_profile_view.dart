import 'dart:html';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uiam_personal/app/data/models/appointment_model.dart';
import 'package:uiam_personal/app/data/models/business_model.dart';
import 'package:uiam_personal/app/data/providers/appointment_provider.dart';
import 'package:uiam_personal/app/data/providers/business_provider.dart';
import 'package:uiam_personal/app/data/providers/firestore_provider.dart';
import 'package:uiam_personal/app/data/providers/timeslot_provider.dart';
import 'package:uiam_personal/app/global/widgets/avatar.dart';
import 'package:uiam_personal/app/global/widgets/drop_shadow.dart';
import 'package:uiam_personal/app/global/widgets/variant_button.dart';
import 'package:uiam_personal/app/global/widgets/variant_progress_button.dart';
import 'package:uiam_personal/core/theme/variant_theme.dart';
import 'package:uiam_personal/core/values/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/timeslot_model.dart';
import '../controllers/business_profile_controller.dart';

class BusinessProfileView extends GetResponsiveView<BusinessProfileController> {
  BusinessProfileView({Key? key}) : super(key: key);
  @override
  Widget builder() {
    return Scaffold(
      body: FutureBuilder(
          future: FirestoreProvider.db
              .collection("businesses")
              .doc(controller.bid!)
              .get(),
          builder: ((context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Something went wrong"));
            }

            if (snapshot.hasData &&
                (snapshot.data == null || !snapshot.data!.exists)) {
              return Center(child: Text("Not Found"));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final business =
                  BusinessModel.fromDocumentSnapshot(snapshot.data!);

              return Scrollbar(
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(dSpace / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: dSpace / 2, vertical: dSpace * 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Avatar(
                              business.image!,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: dSpace),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      business.name!,
                                      style: Get.theme.textTheme.titleLarge,
                                    ),
                                    Text(
                                      business.type!,
                                      style: Get.theme.textTheme.caption,
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          // Expanded(
                          //     flex: 1,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Text(
                          //           "5",
                          //           style: Get.theme.textTheme.titleLarge,
                          //         ),
                          //         Icon(Icons.star)
                          //       ],
                          //     )),
                          Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.location_pin),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.phone),
                                    onPressed: () {},
                                  ),
                                ],
                              )),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: dSpace * 1.5),
                        child: DropShadow(
                          child: VariantButton(
                            content: "Appointment",
                            width: hSize + 2 * dSpace,
                            onTap: () {
                              Get.bottomSheet(_appointment(),
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(borderRadius))),
                                  backgroundColor:
                                      Get.theme.colorScheme.background);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "About",
                          style: Get.theme.textTheme.titleSmall,
                        ),
                      ),
                      SizedBox(
                        height: dSpace / 2,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(business.description!,
                            style: Get.theme.textTheme.bodySmall
                                ?.copyWith(fontSize: 14)),
                      ),
                      SizedBox(
                        height: dSpace,
                      ),
                      Row(children: [
                        Icon(Icons.email, size: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: dSpace / 2),
                          child: Text(business.email!,
                              style: Get.theme.textTheme.bodySmall
                                  ?.copyWith(fontSize: 14)),
                        )
                      ]),
                      SizedBox(
                        height: dSpace / 2,
                      ),
                      Row(children: [
                        Icon(
                          Icons.phone,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: dSpace / 2),
                          child: Text("+91 " + business.phone!,
                              style: Get.theme.textTheme.bodySmall
                                  ?.copyWith(fontSize: 14)),
                        )
                      ]),
                      SizedBox(
                        height: dSpace / 2,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 20,
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: dSpace / 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(business.address!,
                                        style: Get.theme.textTheme.bodySmall
                                            ?.copyWith(fontSize: 14)),
                                    Text(business.place!,
                                        style: Get.theme.textTheme.bodySmall
                                            ?.copyWith(fontSize: 14)),
                                    Text(business.city!,
                                        style: Get.theme.textTheme.bodySmall
                                            ?.copyWith(fontSize: 14)),
                                    Text(business.state!,
                                        style: Get.theme.textTheme.bodySmall
                                            ?.copyWith(fontSize: 14)),
                                    // Text(business.country!,
                                    //     style: Get.theme.textTheme.bodySmall
                                    //         ?.copyWith(fontSize: 14)),
                                    Text(business.postalCode!,
                                        style: Get.theme.textTheme.bodySmall
                                            ?.copyWith(fontSize: 14))
                                  ],
                                ))
                          ]),
                    ],
                  ),
                )),
              );
            }

            return Center(child: CircularProgressIndicator());
          })),
    );
  }

  _appointment() {
    controller.selectedDate.value = null;
    controller.selectedTimeslot.value = null;

    return SizedBox(
      height: Get.height,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(dSpace / 2),
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropShadow(
                  child: DateTimePicker(
                    //initialValue: ,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                    dateLabelText: 'Date',
                    onChanged: (dateStr) {
                      controller.selectedDate.value = DateTime.parse(dateStr);
                    },
                  ),
                ),
                SizedBox(height: dSpace),
                if (controller.selectedDate.value != null)
                  FutureBuilder(
                      future: TimeslotProvider(null).getAvailable(
                          controller.bid!, controller.selectedDate.value!),
                      builder: ((context,
                          AsyncSnapshot<List<TimeslotModel>> snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text("Something went wrong"));
                        }

                        if (snapshot.hasData &&
                            (snapshot.data == null || snapshot.data!.isEmpty)) {
                          return Center(child: Text("No Timeslots available"));
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: dSpace / 2,
                            spacing: dSpace / 2,
                            children: snapshot.data!
                                .map((timeslot) => Obx(() => VariantButton(
                                      width: hSize / 2,
                                      theme:
                                          controller.selectedTimeslot.value ==
                                                  timeslot.id
                                              ? VariantTheme.success
                                              : VariantTheme.primary,
                                      content: timeslot.endTime12 +
                                          " - " +
                                          timeslot.endTime12,
                                      onTap: () {
                                        controller.selectedTimeslot.value =
                                            timeslot.id;
                                      },
                                    )))
                                .toList(),
                          );
                        }

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      })),
                SizedBox(
                  height: dSpace,
                ),
                VariantProgressButton(
                    content: "Make an Appointment",
                    width: 150,
                    onCompleted: () {
                      Get.back();
                    },
                    onTap: () async {
                      if (controller.selectedDate.value == null) {
                        Get.snackbar("Invalid Date", "Select a date",
                            icon: Icon(
                              Icons.error,
                              color: Get.theme.errorColor,
                            ),
                            colorText: Get.theme.errorColor);
                      } else if (controller.selectedTimeslot.value == null) {
                        Get.snackbar("Invalid Timeslot", "Select a timeslot",
                            icon: Icon(
                              Icons.error,
                              color: Get.theme.errorColor,
                            ),
                            colorText: Get.theme.errorColor);
                      } else {
                        return await AppointmentProvider(null).create(
                            model: AppointmentModel(
                                bid: controller.bid!,
                                pid: controller.auth.uid,
                                timeslotId: controller.selectedTimeslot.value!,
                                date: controller.selectedDate.value!));
                      }
                      return null;
                    })
              ],
            )),
      ),
    );
  }
}
