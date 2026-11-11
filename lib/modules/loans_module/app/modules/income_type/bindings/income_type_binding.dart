import 'package:get/get.dart';

import '../controllers/income_type_controller.dart';

class IncomeTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomeTypeController>(
      () => IncomeTypeController(),
    );
  }
}
