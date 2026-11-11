import 'package:get/get.dart';

import '../controllers/pl_status_update_controller.dart';

class PlStatusUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlStatusUpdateController>(
      () => PlStatusUpdateController(),
    );
  }
}
