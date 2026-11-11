import 'package:get/get.dart';

import '../controllers/farmer_list_controller.dart';

class FarmerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmerListController>(
      () => FarmerListController(),
    );
  }
}
