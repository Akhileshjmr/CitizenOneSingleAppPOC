import 'package:get/get.dart';

import '../controllers/buyer_demands_controller.dart';

class BuyerDemandsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerDemandsController>(
      () => BuyerDemandsController(),
    );
  }
}
