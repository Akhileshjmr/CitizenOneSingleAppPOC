import 'package:get/get.dart';

import '../controllers/credit_get_start_controller.dart';

class CreditGetStartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditGetStartController>(
      () => CreditGetStartController(),
    );
  }
}
