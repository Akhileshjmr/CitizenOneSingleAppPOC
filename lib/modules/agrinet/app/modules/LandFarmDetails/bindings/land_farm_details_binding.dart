import 'package:get/get.dart';

import '../controllers/land_farm_details_controller.dart';

class LandFarmDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandFarmDetailsController>(
      () => LandFarmDetailsController(),
    );
  }
}
