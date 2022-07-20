import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:uiam_personal/app/data/models/business_model.dart';
import 'package:uiam_personal/app/data/providers/firestore_provider.dart';
import 'package:uiam_personal/app/global/widgets/avatar.dart';
import 'package:uiam_personal/app/global/widgets/variant_button.dart';
import 'package:uiam_personal/app/routes/app_pages.dart';
import 'package:uiam_personal/core/values/consts.dart';

import '../../../global/widgets/drop_shadow.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scrollbar(
      child: NestedScrollView(
        controller: _scrollController,
        clipBehavior: Clip.none,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [
          SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 150,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(children: [
                      Avatar(
                        controller.auth.user.image!,
                        blurRadius: 55,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: dSpace),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.auth.user.name!,
                              style: Get.theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ))),
          SliverToBoxAdapter(
              child: Container(
                  height: vSize * 2,
                  padding: EdgeInsets.all(dSpace / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(borderRadius),
                        onTap: () {
                          Get.toNamed(Routes.APPOINTMENTS);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(dSpace / 4),
                          child: Column(
                            children: [
                              Icon(Icons.list_alt_rounded),
                              Text("Appointments"),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(borderRadius),
                        onTap: () {
                          Get.toNamed(Routes.QR_CODE);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(dSpace / 4),
                          child: Column(
                            children: [
                              Icon(Icons.qr_code_rounded),
                              Text("Qr Code")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))),
          SliverAppBar(
            backgroundColor: Get.theme.colorScheme.background,
            shadowColor: Get.theme.shadowColor.withOpacity(0.25),
            scrolledUnderElevation: dSpace,
            pinned: true,
            floating: false,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(borderRadius * 5))),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: dSpace,
                ).copyWith(top: dSpace),
                child: TextField(
                  onChanged: (value) =>
                      controller.search.value = value.removeAllWhitespace,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.circular(borderRadius * 5))),
                ),
              ),
            ),
            centerTitle: true,
          ),
        ],
        body: Container(
            child: Obx(
          () => FirestoreListView<Map<String, dynamic>>(
              physics: BouncingScrollPhysics(),
              query: controller.search.value.isNotEmpty
                  ? FirestoreProvider.db
                      .collection('businesses')
                      .orderBy("name")
                      .where("name",
                          isGreaterThanOrEqualTo: controller.search.value)
                      .where("name",
                          isLessThanOrEqualTo:
                              controller.search.value + "\uf7ff")
                  : FirestoreProvider.db.collection('businesses'),
              itemBuilder: (context, snapshot) {
                BusinessModel business =
                    BusinessModel.fromDocumentSnapshot(snapshot);

                return Padding(
                  padding: EdgeInsets.all(dSpace / 2),
                  child: DropShadow(
                    blurRadius: dSpace / 2,
                    shadowOpacity: 0.1,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.BUSINESS_PROFILE,
                            parameters: {"bid": business.id!});
                      },
                      child: Container(
                        padding: EdgeInsets.all(dSpace / 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: Get.theme.colorScheme.background,
                        ),
                        child: Row(children: [
                          Avatar(
                            business.image!,
                            size: 50,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: dSpace),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    business.name!,
                                    style: Get.theme.textTheme.titleMedium,
                                  ),
                                  Text(
                                    business.type!,
                                    style: Get.theme.textTheme.caption,
                                  ),
                                ]),
                          )
                        ]),
                      ),
                    ),
                  ),
                );
              }),
        )),
      ),
    ));
  }
}
