import 'package:get/get.dart';

import '../controllers/creditcard_history_controller.dart';

class CreditcardHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditcardHistoryController>(
      () => CreditcardHistoryController(),
    );
  }
}
