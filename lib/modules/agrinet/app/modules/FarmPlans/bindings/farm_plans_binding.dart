import 'package:get/get.dart';

import '../controllers/farm_plans_controller.dart';

class FarmPlansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmPlansController>(
      () => FarmPlansController(),
    );
  }
}
