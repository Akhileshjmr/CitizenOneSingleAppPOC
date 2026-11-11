import 'package:get/get.dart';

import '../controllers/p_r_emi_calculator_controller.dart';

class PREmiCalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PREmiCalculatorController>(
      () => PREmiCalculatorController(),
    );
  }
}
