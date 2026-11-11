import 'package:get/get.dart';

import '../controllers/pl_features_filter_controller.dart';

class PlFeaturesFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlFeaturesFilterController>(
      () => PlFeaturesFilterController(),
    );
  }
}
