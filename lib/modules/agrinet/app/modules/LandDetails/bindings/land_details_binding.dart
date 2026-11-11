import 'package:get/get.dart';

import '../controllers/land_details_controller.dart';

class LandDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandDetailsController>(
      () => LandDetailsController(),
    );
  }
}
