import 'package:get/get.dart';

import '../controllers/buyer_bid_view_controller.dart';

class BuyerBidViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerBidViewController>(
      () => BuyerBidViewController(),
    );
  }
}
