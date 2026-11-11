import 'package:get/get.dart';

import '../controllers/land_and_corp_details_controller.dart';

class LandAndCorpDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandAndCorpDetailsController>(
      () => LandAndCorpDetailsController(),
    );
  }
}
