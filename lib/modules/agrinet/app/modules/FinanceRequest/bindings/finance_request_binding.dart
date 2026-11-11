import 'package:get/get.dart';

import '../controllers/finance_request_controller.dart';

class FinanceRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinanceRequestController>(
      () => FinanceRequestController(),
    );
  }
}
