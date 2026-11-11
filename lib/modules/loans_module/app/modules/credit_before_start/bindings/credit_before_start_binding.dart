import 'package:get/get.dart';

import '../controllers/credit_before_start_controller.dart';

class CreditBeforeStartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditBeforeStartController>(
      () => CreditBeforeStartController(),
    );
  }
}
