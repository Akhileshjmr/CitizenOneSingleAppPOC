import 'package:get/get.dart';

import '../controllers/buyer_ads_demand_controller.dart';

class BuyerAdsDemandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerAdsDemandController>(
      () => BuyerAdsDemandController(),
    );
  }
}
