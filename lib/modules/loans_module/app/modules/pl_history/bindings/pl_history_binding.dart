import 'package:get/get.dart';

import '../controllers/pl_history_controller.dart';

class PlHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlHistoryController>(
      () => PlHistoryController(),
    );
  }
}
