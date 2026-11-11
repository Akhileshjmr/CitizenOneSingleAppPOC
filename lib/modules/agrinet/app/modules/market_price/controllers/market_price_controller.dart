import 'package:citizenone_app/modules/agrinet/app/modules/market_filter/controllers/market_filter_controller.dart';
import 'package:get/get.dart';

import '../../../data/model/market/market_response.dart';
import '../../../data/provider/market_filter.dart';

class MarketPriceController extends GetxController {
  var isLoading = false.obs;
  var marketResponse = Rxn<MarketResponse>();

  @override
  void onInit() {
    fetchPrices();
    super.onInit();
  }

  Future<void> fetchPrices() async {
    try {
      isLoading.value = true;

      final controller = Get.find<MarketFilterController>();

      final fromDate = controller.fromDate.value;
      final toDate = controller.toDate.value;
      final selectedState = controller.selectedState.value;
      final selectedCommodity = controller.selectedCommodity.value;

      final requestBody = {
        "fromDate": fromDate,
        "toDate": toDate,
        "state": selectedState?.friendlyType,
        "commodity": selectedCommodity?.friendlyType,
      };

      requestBody.removeWhere((key, value) => value == null);

      final data = await MarketFilterService.getCommoditiesPrice(
        data: requestBody,
      );

      if (data != null) {
        marketResponse.value = data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
