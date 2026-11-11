import 'package:get/get.dart';

import '../controllers/pl_filter_product_controller.dart';

class PlFilterProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlFilterProductController>(
      () => PlFilterProductController(),
    );
  }
}
