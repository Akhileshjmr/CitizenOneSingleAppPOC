import 'package:get/get.dart';

import '../controllers/auto_vehicle_form_controller.dart';

class AutoVehicleFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutoVehicleFormController>(
      () => AutoVehicleFormController(),
    );
  }
}
