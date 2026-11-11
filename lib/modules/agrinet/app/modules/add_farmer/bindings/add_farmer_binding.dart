import 'package:get/get.dart';

import '../controllers/add_farmer_controller.dart';

class AddFarmerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFarmerController>(
      () => AddFarmerController(),
    );
  }
}
