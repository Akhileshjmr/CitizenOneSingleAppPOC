import 'package:get/get.dart';

import '../controllers/market_filter_controller.dart';

class MarketFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketFilterController>(
      () => MarketFilterController(),
    );
  }
}
