import 'package:get/get.dart';

import '../controllers/credit_third_screen_controller.dart';

class CreditThirdScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditThirdScreenController>(
      () => CreditThirdScreenController(),
    );
  }
}
