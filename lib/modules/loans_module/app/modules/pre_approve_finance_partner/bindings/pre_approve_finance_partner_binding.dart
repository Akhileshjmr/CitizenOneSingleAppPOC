import 'package:get/get.dart';

import '../controllers/pre_approve_finance_partner_controller.dart';

class PreApproveFinancePartnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreApproveFinancePartnerController>(
      () => PreApproveFinancePartnerController(),
    );
  }
}
