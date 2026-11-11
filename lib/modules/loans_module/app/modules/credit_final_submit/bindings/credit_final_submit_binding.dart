import 'package:get/get.dart';

import '../controllers/credit_final_submit_controller.dart';

class CreditFinalSubmitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditFinalSubmitController>(
      () => CreditFinalSubmitController(),
    );
  }
}
