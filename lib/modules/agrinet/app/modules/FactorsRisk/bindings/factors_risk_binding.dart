import 'package:get/get.dart';

import '../controllers/factors_risk_controller.dart';

class FactorsRiskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FactorsRiskController>(
      () => FactorsRiskController(),
    );
  }
}
