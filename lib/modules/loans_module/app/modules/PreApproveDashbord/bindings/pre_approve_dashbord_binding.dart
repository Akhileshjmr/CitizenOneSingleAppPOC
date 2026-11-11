import 'package:get/get.dart';

import '../controllers/pre_approve_dashbord_controller.dart';

class PreApproveDashbordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreApproveDashbordController>(
      () => PreApproveDashbordController(),
    );
  }
}
