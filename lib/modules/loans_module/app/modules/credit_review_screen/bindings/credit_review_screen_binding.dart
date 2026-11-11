import 'package:get/get.dart';

import '../controllers/credit_review_screen_controller.dart';

class CreditReviewScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditReviewScreenController>(
      () => CreditReviewScreenController(),
    );
  }
}
