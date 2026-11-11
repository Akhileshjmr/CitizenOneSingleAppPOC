import 'dart:async';

import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/model/farmPlan/FarmPlansResp.dart';
import '../../../data/provider/FarmPlanService.dart';

class FarmPlansController extends GetxController {
  // Data
  Rx<FarmPlansResp> allPlans = FarmPlansResp().obs;
  Rx<FarmPlansResp> filteredPlans = FarmPlansResp().obs;

  // UI States
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchPlan();
  }

  // ===============================
  // Fetch API
  // ===============================
  Future<void> fetchPlan() async {
    try {
      isLoading(true);
      hasError(false);

      final result = await FarmPlanService.fetchFarmList(
        reqSecureKey: '${UserPrefs.user?.userId}',
        screenId: 'FARMINGPLAN_LIST',
      );

      // Store result
      allPlans(result);
      filteredPlans(result);
    } catch (e) {
      print("Fetch Error: $e");

      hasError(true);
    } finally {
      isLoading(false);
    }
  }

  // ===============================
  // Search Handler
  // ===============================
  void filterPlans(String text) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _applyFilter(text);
    });
  }

  void _applyFilter(String text) {
    if (text.isEmpty) {
      filteredPlans(allPlans.value);
      return;
    }

    final query = text.toLowerCase();
    final original = allPlans.value;

    if (original.selectAppStatus == null) {
      filteredPlans(original);
      return;
    }

    final filteredStatusList =
        original.selectAppStatus!
            .map((status) {
              final filteredAgriList =
                  status.agriFramdet?.where((item) {
                    final planId = item.planId?.toLowerCase() ?? '';
                    final planName = item.planName?.toLowerCase() ?? '';
                    final appStatus = item.appStatus?.toLowerCase() ?? '';

                    return planId.contains(query) ||
                        planName.contains(query) ||
                        appStatus.contains(query);
                  }).toList();

              if (filteredAgriList == null || filteredAgriList.isEmpty) {
                return null;
              }

              return SelectAppStatus(
                key: status.key,
                agriFramdet: filteredAgriList,
              );
            })
            .whereType<SelectAppStatus>()
            .toList();

    final filteredResponse = FarmPlansResp(
      reqSecureKey: original.reqSecureKey,
      screenId: original.screenId,
      status: original.status,
      chMessage: original.chMessage,
      selectAppStatus: filteredStatusList,
    );

    filteredPlans(filteredResponse);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
