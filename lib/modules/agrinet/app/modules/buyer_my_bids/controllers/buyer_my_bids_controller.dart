import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/model/view_bids/one_advertise_history.dart';
import '../../../data/provider/buyer_bids_services.dart';

class BuyerMyBidsController extends GetxController {
  RxList<BidPlan> bids = <BidPlan>[].obs;
  List<BidPlan> originalBids = <BidPlan>[];

  TextEditingController searchController = TextEditingController();

  final selectedBid = Rx<BidPlan?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMyBids();
  }

  Future<void> loadMyBids() async {
    isLoading.value = true;
    searchController.clear();

    final res = await BuyerBidsService.fetchMyBids();

    if (res != null) {
      originalBids = res.bidplanList ?? [];
      bids.assignAll(originalBids);
    }

    isLoading.value = false;
  }

  /// ============ SEARCH FUNCTION ============
  void filterBids(String query) {
    if (query.isEmpty) {
      bids.assignAll(originalBids);
      return;
    }

    final lowerQuery = query.toLowerCase();

    bids.assignAll(
      originalBids.where((item) {
        /// safe strings
        final crop = item.cropName?.toLowerCase() ?? "";
        final code = item.adId?.toLowerCase() ?? "";
        final quantity = item.totalQuantity?.toLowerCase() ?? "";
        final status = item.status?.friendlyType?.toLowerCase() ?? "";

        /// match any field
        return crop.contains(lowerQuery) ||
            code.contains(lowerQuery) ||
            quantity.contains(lowerQuery) ||
            status.contains(lowerQuery);
      }).toList(),
    );
  }
}
