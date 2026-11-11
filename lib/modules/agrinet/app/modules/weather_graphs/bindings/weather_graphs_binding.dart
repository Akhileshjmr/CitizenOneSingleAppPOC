import 'package:get/get.dart';

import '../controllers/weather_graphs_controller.dart';

class WeatherGraphsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherGraphsController>(
      () => WeatherGraphsController(),
    );
  }
}
