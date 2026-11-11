import 'package:get/get.dart';

import '../controllers/p_r_uploan_history_controller.dart';

class PRUploanHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PRUploanHistoryController>(
      () => PRUploanHistoryController(),
    );
  }
}
