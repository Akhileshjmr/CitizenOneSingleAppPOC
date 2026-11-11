import 'package:get/get.dart';

import '../controllers/buyer_my_bids_controller.dart';

class BuyerMyBidsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerMyBidsController>(
      () => BuyerMyBidsController(),
    );
  }
}
