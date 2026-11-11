import 'package:get/get.dart';

import '../controllers/success_info_controller.dart';

class SuccessInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccessInfoController>(
      () => SuccessInfoController(),
    );
  }
}
