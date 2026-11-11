import 'package:get/get.dart';

import '../controllers/auto_loan_track_order_status_controller.dart';

class AutoLoanTrackOrderStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutoLoanTrackOrderStatusController>(
      () => AutoLoanTrackOrderStatusController(),
    );
  }
}
