import 'package:get/get.dart';

import '../controllers/pl_review_submit_controller.dart';

class PlReviewSubmitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlReviewSubmitController>(
      () => PlReviewSubmitController(),
    );
  }
}
