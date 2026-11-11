import 'package:get/get.dart';

import '../controllers/auto_loan_insurance_controller.dart';

class AutoLoanInsuranceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutoLoanInsuranceController>(
      () => AutoLoanInsuranceController(),
    );
  }
}
