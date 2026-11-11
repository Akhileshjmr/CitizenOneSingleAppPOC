import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/model/view_bids/adverise_history_list.dart';
import '../../../data/provider/buyer_bids_services.dart';

class BuyerHomeController extends GetxController {
  RxList<AdvertiseProduce> advertiseHistoryList = <AdvertiseProduce>[].obs;
  List<AdvertiseProduce> originalAdvertiseList = [];

  RxBool isLoading = false.obs;
  AdvertiseProduce? selectedAdvertiseProduce;

  TextEditingController searchController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    fetchAdvertiseHistoryList();
  }

  Future<void> fetchAdvertiseHistoryList() async {
    try {
      searchController.clear();
      isLoading(true);
      final response = await BuyerBidsService.fetchAdvertiseHistory();

      if (response != null && response.advertiseProduce != null) {
        originalAdvertiseList = response.advertiseProduce!;
        advertiseHistoryList.assignAll(originalAdvertiseList);
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  void filterAds(String query) {
    if (query.isEmpty) {
      advertiseHistoryList.assignAll(originalAdvertiseList);
      return;
    }

    final lowerQuery = query.toLowerCase();

    advertiseHistoryList.assignAll(
      originalAdvertiseList.where((item) {
        final crop =
            (item.cropName != null &&
                    item.cropName!.isNotEmpty &&
                    item.cropName!.first.cropName != null)
                ? item.cropName!.first.cropName!.toLowerCase()
                : "";

        // -------- SAFE ID STRING ----------
        final code = (item.id ?? "").toLowerCase();

        // -------- SUBSTRING SEARCH ----------
        // Matches even middle part like "348"
        return crop.contains(lowerQuery) || code.contains(lowerQuery);
      }).toList(),
    );
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
