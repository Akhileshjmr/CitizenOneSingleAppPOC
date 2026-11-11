import 'package:get/get.dart';

import '../controllers/co_referal_controller.dart';

class CoReferalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoReferalController>(
      () => CoReferalController(),
    );
  }
}
