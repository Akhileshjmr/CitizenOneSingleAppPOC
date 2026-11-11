import 'package:get/get.dart';

import '../controllers/cg_payment_success_controller.dart';

class CgPaymentSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CgPaymentSuccessController>(
      () => CgPaymentSuccessController(),
    );
  }
}
