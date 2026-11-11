import 'package:get/get.dart';

import '../controllers/real_estate_loan_history_controller.dart';

class RealEstateLoanHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RealEstateLoanHistoryController>(
      () => RealEstateLoanHistoryController(),
    );
  }
}
