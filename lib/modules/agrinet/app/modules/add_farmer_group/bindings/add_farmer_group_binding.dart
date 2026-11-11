import 'package:get/get.dart';

import '../controllers/add_farmer_group_controller.dart';

class AddFarmerGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFarmerGroupController>(
      () => AddFarmerGroupController(),
    );
  }
}
