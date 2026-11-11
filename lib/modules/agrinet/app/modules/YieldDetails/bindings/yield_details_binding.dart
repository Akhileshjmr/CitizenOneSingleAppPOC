import 'package:get/get.dart';

import '../controllers/yield_details_controller.dart';

class YieldDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YieldDetailsController>(
      () => YieldDetailsController(),
    );
  }
}
