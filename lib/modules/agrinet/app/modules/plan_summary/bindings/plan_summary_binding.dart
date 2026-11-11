import 'package:get/get.dart';

import '../controllers/plan_summary_controller.dart';

class PlanSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanSummaryController>(
      () => PlanSummaryController(),
    );
  }
}
