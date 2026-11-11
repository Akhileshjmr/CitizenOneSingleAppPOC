import 'package:get/get.dart';

import '../controllers/sign_up_type_controller.dart';

class SignUpTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpTypeController>(
      () => SignUpTypeController(),
    );
  }
}
