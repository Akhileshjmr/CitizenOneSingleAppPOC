import 'package:get/get.dart';

import '../controllers/auto_loan_order_status_controller.dart';

class AutoLoanOrderStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutoLoanOrderStatusController>(
      () => AutoLoanOrderStatusController(),
    );
  }
}
