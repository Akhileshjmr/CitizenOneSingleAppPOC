import 'package:get/get.dart';

import '../controllers/pl_compare_product_controller.dart';

class PlCompareProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlCompareProductController>(
      () => PlCompareProductController(),
    );
  }
}
