import 'package:get/get.dart';

import '../controllers/auto_loan_history_controller.dart';

class AutoLoanHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutoLoanHistoryController>(
      () => AutoLoanHistoryController(),
    );
  }
}
