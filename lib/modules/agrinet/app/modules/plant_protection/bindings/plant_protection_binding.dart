import 'package:get/get.dart';

import '../controllers/plant_protection_controller.dart';

class PlantProtectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlantProtectionController>(
      () => PlantProtectionController(),
    );
  }
}
