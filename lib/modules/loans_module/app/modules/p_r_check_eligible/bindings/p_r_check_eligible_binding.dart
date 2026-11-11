import 'package:get/get.dart';

import '../controllers/p_r_check_eligible_controller.dart';

class PRCheckEligibleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PRCheckEligibleController>(
      () => PRCheckEligibleController(),
    );
  }
}
