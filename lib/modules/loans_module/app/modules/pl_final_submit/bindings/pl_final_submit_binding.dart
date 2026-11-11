import 'package:get/get.dart';

import '../controllers/pl_final_submit_controller.dart';

class PlFinalSubmitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlFinalSubmitController>(
      () => PlFinalSubmitController(),
    );
  }
}
