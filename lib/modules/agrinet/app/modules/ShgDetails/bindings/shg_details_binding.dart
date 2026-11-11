import 'package:get/get.dart';

import '../controllers/shg_details_controller.dart';

class ShgDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShgDetailsController>(
      () => ShgDetailsController(),
    );
  }
}
