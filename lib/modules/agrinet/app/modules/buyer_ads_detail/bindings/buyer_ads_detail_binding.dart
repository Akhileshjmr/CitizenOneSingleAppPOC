import 'package:get/get.dart';

import '../controllers/buyer_ads_detail_controller.dart';

class BuyerAdsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerAdsDetailController>(
      () => BuyerAdsDetailController(),
    );
  }
}
