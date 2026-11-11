import 'package:get/get.dart';

import '../controllers/soil_assessment_controller.dart';

class SoilAssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SoilAssessmentController>(
      () => SoilAssessmentController(),
    );
  }
}
