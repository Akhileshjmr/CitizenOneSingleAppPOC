import 'package:get/get.dart';

import '../controllers/insurance_acceptance_controller.dart';

class InsuranceAcceptanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsuranceAcceptanceController>(
      () => InsuranceAcceptanceController(),
    );
  }
}
