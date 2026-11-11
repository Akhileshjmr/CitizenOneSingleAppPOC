import 'package:get/get.dart';

import '../controllers/auto_orders_controller.dart';

class AutoOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutoOrdersController>(
      () => AutoOrdersController(),
    );
  }
}
