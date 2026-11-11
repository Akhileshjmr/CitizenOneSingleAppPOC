import 'package:get/get.dart';

import '../controllers/farm_plan_list_controller.dart';

class FarmPlanListViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmPlanListController>(() => FarmPlanListController());
  }
}
