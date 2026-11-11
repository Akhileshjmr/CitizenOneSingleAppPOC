import 'package:get/get.dart';

import '../controllers/soil_maps_controller.dart';

class SoilMapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SoilMapsController>(
      () => SoilMapsController(),
    );
  }
}
