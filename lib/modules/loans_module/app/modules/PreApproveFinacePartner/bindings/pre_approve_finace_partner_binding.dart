import 'package:get/get.dart';

import '../controllers/pre_approve_finace_partner_controller.dart';

class PreApproveFinacePartnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreApproveFinacePartnerController>(
      () => PreApproveFinacePartnerController(),
    );
  }
}
