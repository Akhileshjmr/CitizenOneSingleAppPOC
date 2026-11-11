import 'package:get/get.dart';

import '../controllers/pl_chat_controller.dart';

class PlChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlChatController>(
      () => PlChatController(),
    );
  }
}
