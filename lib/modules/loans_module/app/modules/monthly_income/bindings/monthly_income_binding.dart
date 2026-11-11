import 'package:get/get.dart';

import '../controllers/monthly_income_controller.dart';

class MonthlyIncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MonthlyIncomeController>(
      () => MonthlyIncomeController(),
    );
  }
}
