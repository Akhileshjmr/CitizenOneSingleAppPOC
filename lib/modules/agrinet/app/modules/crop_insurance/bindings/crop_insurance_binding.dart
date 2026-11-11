import 'package:get/get.dart';

import '../controllers/crop_insurance_controller.dart';

class CropInsuranceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CropInsuranceController>(
      () => CropInsuranceController(),
    );
  }
}
