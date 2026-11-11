import 'package:get/get.dart';

import '../controllers/agri_input_controller.dart';

class AgriInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgriInputController>(
      () => AgriInputController(),
    );
  }
}
