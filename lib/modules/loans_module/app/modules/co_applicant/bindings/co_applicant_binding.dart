import 'package:get/get.dart';

import '../controllers/co_applicant_controller.dart';

class CoApplicantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoApplicantController>(
      () => CoApplicantController(),
    );
  }
}
