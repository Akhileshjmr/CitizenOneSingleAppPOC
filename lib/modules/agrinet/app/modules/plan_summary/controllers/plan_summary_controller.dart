import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:get/get.dart';

import '../../../data/model/plan_summary/plan_summary_model.dart';
import '../../../data/provider/plan_summary.dart';

class PlanSummaryController extends GetxController {
  var isLoading = false.obs;
  var planList = <FarmPlan>[].obs;

  @override
  void onInit() {
    fetchPlanSummary();
    super.onInit();
  }

  Future<void> fetchPlanSummary() async {
    try {
      isLoading.value = true;

      var responseJson = await PlanSummeryService.getPlanSummery(
        request: {
          "filterVal": "PLAN_SUMMARY",
          "reqSecureKey": UserPrefs.user?.userId,
        },
      );

      planList.value = responseJson.farmPlanList ?? [];
    } catch (e) {
      print("Error loading plans: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
