import 'dart:html';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uiam_personal/app/data/models/business_model.dart';
import 'package:uiam_personal/app/data/providers/business_provider.dart';
import 'package:uiam_personal/app/data/providers/firestore_provider.dart';
import 'package:uiam_personal/app/global/widgets/avatar.dart';
import 'package:uiam_personal/app/global/widgets/drop_shadow.dart';
import 'package:uiam_personal/app/global/widgets/variant_button.dart';
import 'package:uiam_personal/core/theme/variant_theme.dart';
import 'package:uiam_personal/core/values/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/business_profile_controller.dart';

class BusinessProfileView extends GetView<BusinessProfileController> {
  const BusinessProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("#######object");
    print(controller.bid!);
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

            if (snapshot.data == null ||
                (snapshot.hasData && !snapshot.data!.exists)) {
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
                            onTap: () {},
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
                      // Row(children: [
                      //   Icon(
                      //     Icons.phone,
                      //     size: 20,
                      //   ),
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: dSpace / 2),
                      //     child: Text("+91 " + business.phone!,
                      //         style: Get.theme.textTheme.bodySmall
                      //             ?.copyWith(fontSize: 14)),
                      //   )
                      // ]),
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
}
