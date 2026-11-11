import 'package:get/get.dart';

import '../../../data/remote/providers/google_map_service.dart';
import '../controllers/measure_land_controller.dart';

class MeasureLandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GoogleMapService());
    Get.lazyPut(() => MeasureLandController());
  }
}
