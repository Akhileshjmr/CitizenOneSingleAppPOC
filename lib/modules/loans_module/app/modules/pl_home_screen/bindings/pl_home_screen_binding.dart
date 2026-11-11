import 'package:get/get.dart';

import '../controllers/pl_home_screen_controller.dart';

class PlHomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlHomeScreenController>(
      () => PlHomeScreenController(),
    );
  }
}
