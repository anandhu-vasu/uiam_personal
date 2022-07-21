import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uiam_personal/core/values/consts.dart';
import '../../../../core/values/strings.dart';
import '../controllers/qr_code_controller.dart';

class QrCodeView extends GetView<QrCodeController> {
  const QrCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.primary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              appNameShort,
              style: TextStyle(
                color: Get.theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            Text(
              appFor.toUpperCase(),
              style: TextStyle(
                color: Get.theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            SizedBox(
              height: dSpace,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: QrImage(
                    data: controller.auth.uid,
                    version: QrVersions.auto,
                    size: 220,
                    gapless: false,
                    /*embeddedImage:
                        CachedNetworkImageProvider(controller.auth.user.image!),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(80, 80),
                    ),*/
                  ),
                ),
              ],
            ),
            SizedBox(
              height: dSpace,
            ),
            Text(
              controller.auth.user.name!,
              style: Get.theme.textTheme.titleLarge?.copyWith(
                color: Get.theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ));
  }
}
