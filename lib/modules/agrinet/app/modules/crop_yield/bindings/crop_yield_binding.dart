import 'package:get/get.dart';

import '../controllers/crop_yield_controller.dart';

class CropYieldBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CropYieldController>(
      () => CropYieldController(),
    );
  }
}
