import 'package:get/get.dart';

import '../controllers/farmer_profile_controller.dart';

class FarmerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmerProfileController>(
      () => FarmerProfileController(),
    );
  }
}
