import 'package:get/get.dart';

import '../controllers/credit_benefits_option_controller.dart';

class CreditBenefitsOptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditBenefitsOptionController>(
      () => CreditBenefitsOptionController(),
    );
  }
}
