import 'package:get/get.dart';

import '../controllers/creditcard_track_controller.dart';

class CreditcardTrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditcardTrackController>(
      () => CreditcardTrackController(),
    );
  }
}
