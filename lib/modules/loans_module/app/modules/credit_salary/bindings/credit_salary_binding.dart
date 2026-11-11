import 'package:get/get.dart';

import '../controllers/credit_salary_controller.dart';

class CreditSalaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditSalaryController>(
      () => CreditSalaryController(),
    );
  }
}
