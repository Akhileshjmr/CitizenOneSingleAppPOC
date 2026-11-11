import 'package:get/get.dart';

import '../controllers/event_display_controller.dart';

class EventDisplayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventDisplayController>(
      () => EventDisplayController(),
    );
  }
}
