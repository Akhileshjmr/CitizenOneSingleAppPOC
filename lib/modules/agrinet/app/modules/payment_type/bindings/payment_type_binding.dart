import 'package:get/get.dart';

import '../controllers/payment_type_controller.dart';

class PaymentTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentTypeController>(
      () => PaymentTypeController(),
    );
  }
}
