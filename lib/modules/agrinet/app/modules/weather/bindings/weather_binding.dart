import 'package:get/get.dart';

import '../../../data/remote/providers/google_map_service.dart';
import '../controllers/weather_controller.dart';

class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleMapService>(() => GoogleMapService());

    Get.lazyPut<WeatherController>(() => WeatherController());
  }
}
