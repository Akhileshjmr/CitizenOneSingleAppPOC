import 'package:get/get.dart';

import '../controllers/p_r_check_emi_controller.dart';

class PRCheckEmiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PRCheckEmiController>(
      () => PRCheckEmiController(),
    );
  }
}
