import 'package:get/get.dart';

import '../controllers/pal_creation_controller.dart';

class PalCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PalCreationController>(
      () => PalCreationController(),
    );
  }
}
