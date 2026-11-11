import 'package:get/get.dart';

import '../controllers/communication_details_controller.dart';

class CommunicationDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommunicationDetailsController>(
      () => CommunicationDetailsController(),
    );
  }
}
