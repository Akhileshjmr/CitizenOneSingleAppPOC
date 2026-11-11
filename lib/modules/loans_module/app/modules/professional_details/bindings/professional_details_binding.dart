import 'package:get/get.dart';

import '../controllers/professional_details_controller.dart';

class ProfessionalDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfessionalDetailsController>(
      () => ProfessionalDetailsController(),
    );
  }
}
