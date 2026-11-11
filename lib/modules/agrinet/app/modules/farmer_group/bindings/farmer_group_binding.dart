import 'package:get/get.dart';

import '../controllers/farmer_group_controller.dart';

class FarmerGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmerGroupController>(
      () => FarmerGroupController(),
    );
  }
}
