import 'package:get/get.dart';

import '../controllers/credit_filters_controller.dart';

class CreditFiltersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditFiltersController>(
      () => CreditFiltersController(),
    );
  }
}
