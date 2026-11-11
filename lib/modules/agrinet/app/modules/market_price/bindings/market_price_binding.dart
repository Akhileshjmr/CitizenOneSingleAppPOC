import 'package:get/get.dart';

import '../controllers/market_price_controller.dart';

class MarketPriceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketPriceController>(
      () => MarketPriceController(),
    );
  }
}
