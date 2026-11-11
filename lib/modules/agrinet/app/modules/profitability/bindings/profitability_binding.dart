import 'package:get/get.dart';

import '../controllers/profitability_controller.dart';

class ProfitabilityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfitabilityController>(
      () => ProfitabilityController(),
    );
  }
}
