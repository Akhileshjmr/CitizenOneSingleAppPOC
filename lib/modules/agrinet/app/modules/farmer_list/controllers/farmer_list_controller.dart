import 'package:get/get.dart';

import '../../../data/model/onboarding/onboarding_farmer_list.dart';
import '../../../data/provider/onboard_service.dart';

class FarmerListController extends GetxController {
  FarmerOnBoardList? farmers;

  RxList<FarmerOnBoard> filteredFarmers = <FarmerOnBoard>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      farmers = await OnboardService.fetchFarmerList();

      // Store initial list into filtered list
      filteredFarmers.assignAll(farmers?.farmerOnBoard ?? []);
    } finally {
      isLoading(false);
    }
  }

  /// 🔍 FILTER FUNCTION
  void filterFarmers(String query) {
    if (query.isEmpty) {
      filteredFarmers.assignAll(farmers?.farmerOnBoard ?? []);
      return;
    }

    query = query.toLowerCase();

    filteredFarmers.assignAll(
      farmers!.farmerOnBoard!.where((f) {
        final name = f.generalDetails?.name?.toLowerCase() ?? "";
        final id = f.bankDetails?.formerId?.friendlyType?.toLowerCase() ?? "";
        return name.contains(query) || id.contains(query);
      }).toList(),
    );
  }
}
