import 'package:get/get.dart';

import '../../../data/model/plan/group_farming_plan.dart';
import '../../../data/model/profitability/profitability_response.dart';
import '../../../data/provider/profitability_service.dart';

class ProfitabilityController extends GetxController {
  final ProfitabilityService _service = ProfitabilityService();

  /// Complete profitability response
  Rx<ProfitabilityResponse?> profitability = Rx<ProfitabilityResponse?>(null);

  /// Toggle between Group Earnings (true) and Farmer Earnings (false)
  RxBool showGroupEarnings = true.obs;
  RxBool showAnySection = false.obs;
  RxBool isLoading = false.obs;

  /// The selected plan ID
  late final FarmingPlanItem selectedPlan;

  @override
  void onInit() {
    super.onInit();

    /// Get selected plan from previous screen
    selectedPlan = Get.arguments as FarmingPlanItem;

    /// Fetch details automatically
    loadProfitability();
  }

  /// ---------------------------------------------------
  /// FETCH PROFITABILITY DETAILS
  /// ---------------------------------------------------
  Future<void> loadProfitability() async {
    try {
      isLoading.value = true;
      final result = await _service.fetchProfitability(selectedPlan.planId);
      profitability.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------------------------------------------
  /// TAB SWITCH HANDLER
  /// ---------------------------------------------------
  void switchTab(bool isGroup) {
    showGroupEarnings.value = isGroup;
    showAnySection.value = true;
  }
}
