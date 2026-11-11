import 'package:get/get.dart';

import '../controllers/pl_status_controller.dart';

class PlStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlStatusController>(
      () => PlStatusController(),
    );
  }
}
