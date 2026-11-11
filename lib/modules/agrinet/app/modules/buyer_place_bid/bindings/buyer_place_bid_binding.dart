import 'package:get/get.dart';

import '../controllers/buyer_place_bid_controller.dart';

class BuyerPlaceBidBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerPlaceBidController>(
      () => BuyerPlaceBidController(),
    );
  }
}
