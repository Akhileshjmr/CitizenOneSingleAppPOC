import 'package:get/get.dart';

import '../../../data/model/buyer_demand/buyer_demand_item.dart';
import '../../../data/provider/buyer_demand_service.dart';

class BuyerDemandsController extends GetxController {
  RxBool isLoading = false.obs;

  /// Main list used by UI
  RxList<BuyerDemandItem> demands = <BuyerDemandItem>[].obs;

  /// Backup original list
  List<BuyerDemandItem> originalList = [];

  /// Load from API
  Future<void> loadDemands() async {
    try {
      isLoading.value = true;

      final res = await BuyerDemandService.fetchBuyerDemands();

      if (res != null) {
        originalList = res.items;
        demands.assignAll(res.items);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// SEARCH FUNCTION
  void onSearch(String query) {
    if (query.isEmpty) {
      demands.assignAll(originalList);
      return;
    }

    final q = query.toLowerCase();

    demands.assignAll(
      originalList.where((item) {
        // Crop name search
        final crop = item.cropName.toLowerCase();

        // ID search
        final id = item.buyerCommodityId.toString().toLowerCase();

        return crop.contains(q) || id.contains(q);
      }).toList(),
    );
  }

  @override
  void onInit() {
    loadDemands();
    super.onInit();
  }
}
