import 'dart:ui';

import 'package:get/get.dart';

class SuccessInfoController extends GetxController {
  late String title;
  late String message;
  late VoidCallback onOk;

  @override
  void onInit() {
    title = Get.arguments["title"];
    message = Get.arguments["message"];
    onOk = Get.arguments["onOk"];
    super.onInit();
  }

  void handleOk() {
    onOk(); // perform the custom navigation
  }
}
