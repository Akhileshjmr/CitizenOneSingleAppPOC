import 'package:get/get.dart';

import '../controllers/pl_check_emi_controller.dart';

class PlCheckEmiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlCheckEmiController>(
      () => PlCheckEmiController(),
    );
  }
}
