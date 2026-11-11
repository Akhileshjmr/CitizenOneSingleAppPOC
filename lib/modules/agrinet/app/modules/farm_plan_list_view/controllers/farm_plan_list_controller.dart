import 'package:citizenone_app/modules/agrinet/app/data/provider/plan_service.dart';
import 'package:get/get.dart';

import '../../../data/model/plan/group_farming_plan.dart';

class FarmPlanListController extends GetxController {
  final PlanService _service = PlanService();

  RxList<FarmingPlanItem> fullList = <FarmingPlanItem>[].obs;
  RxList<FarmingPlanItem> filteredList = <FarmingPlanItem>[].obs;

  ///for pagination
  int currentPage = 1;
  bool hasMore = true;
  RxBool isLoadingMore = false.obs;

  ///Screen Loader
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchList(currentPage);
    super.onInit();
  }

  /// -----------------------------
  /// FIRST + PAGINATED FETCH
  /// -----------------------------
  Future<void> fetchList(int page) async {
    try {
      isLoading.value = true;
      final result = await _service.fetchFarmingPlanList(page);

      if (result.isEmpty) {
        hasMore = false;
        return;
      }

      fullList.addAll(result);
      filteredList.assignAll(fullList);
    } finally {
      isLoading.value = false;
    }
  }

  /// -----------------------------
  /// LOAD NEXT PAGE WHEN SCROLLING
  /// -----------------------------
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;

    isLoadingMore.value = true;
    currentPage++;

    final result = await _service.fetchFarmingPlanList(currentPage);

    if (result.isEmpty) {
      hasMore = false;
    } else {
      fullList.addAll(result);
      filteredList.assignAll(fullList);
    }

    isLoadingMore.value = false;
  }

  /// -----------------------------
  /// SEARCH FUNCTIONALITY
  /// -----------------------------
  void onSearch(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(fullList); // Reset list
      return;
    }

    final lower = query.toLowerCase();

    filteredList.assignAll(
      fullList.where(
        (e) =>
            e.groupName.toLowerCase().contains(lower) ||
            e.planId.toLowerCase().contains(lower),
      ),
    );
  }
}
