import 'package:get/get.dart';

import '../controllers/fin_details_controller.dart';

class FinDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinDetailsController>(
      () => FinDetailsController(),
    );
  }
}
