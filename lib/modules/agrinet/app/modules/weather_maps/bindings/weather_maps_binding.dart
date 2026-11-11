import 'package:get/get.dart';

import '../../../data/remote/providers/google_map_service.dart';
import '../controllers/weather_maps_controller.dart';

class WeatherMapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleMapService>(() => GoogleMapService());

    Get.lazyPut<WeatherMapsController>(() => WeatherMapsController());
  }
}
