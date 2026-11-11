import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  bool navigated = false;

  @override
  void onReady() {
    super.onReady();
    _goToHome();
  }

  Future<void> _goToHome() async {
    if (navigated) return;
    navigated = true;

    await Future.delayed(const Duration(seconds: 3));

    if (Get.currentRoute == Routes.SPLASH) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
