import 'package:get/get.dart';

import '../controllers/credit_home_controller.dart';

class CreditHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditHomeController>(
      () => CreditHomeController(),
    );
  }
}
