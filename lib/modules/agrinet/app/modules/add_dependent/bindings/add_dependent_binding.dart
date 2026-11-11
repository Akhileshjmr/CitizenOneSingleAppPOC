import 'package:get/get.dart';

import '../controllers/add_dependent_controller.dart';

class AddDependentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDependentController>(
      () => AddDependentController(),
    );
  }
}
