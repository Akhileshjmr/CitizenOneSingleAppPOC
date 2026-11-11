import 'package:get/get.dart';

import '../controllers/insurance_detail_controller.dart';

class InsuranceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsuranceDetailController>(
      () => InsuranceDetailController(),
    );
  }
}
