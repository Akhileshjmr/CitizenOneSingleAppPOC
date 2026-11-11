import 'package:get/get.dart';

import '../controllers/property_form_controller.dart';

class PropertyFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PropertyFormController>(
      () => PropertyFormController(),
    );
  }
}
