import 'package:get/get.dart';

import '../controllers/income_detail_controller.dart';

class IncomeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomeDetailController>(
      () => IncomeDetailController(),
    );
  }
}
