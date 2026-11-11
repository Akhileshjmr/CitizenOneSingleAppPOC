import 'package:get/get.dart';

import '../../../data/provider/performance_service.dart';

class PerformanceController extends GetxController {
  final RxBool isLoading = true.obs;

  final RxMap<String, int> data =
      <String, int>{
        'OnBoard': 0,
        'Group': 0,
        'Service': 0,
        'Plans': 0,
        'Ads': 0,
        'Bank': 0,
        'BID': 0,
        'Payment': 0,
      }.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadPerformanceData();
  }

  Future<void> loadPerformanceData() async {
    isLoading.value = true;

    final response = await PerformanceService.fetchPerformance();

    if (response != null) {
      data['OnBoard'] = response.farmersOnboarded ?? 0;
      data['Group'] = response.groupsCreated ?? 0;
      data['Service'] = response.serviceRequestsRaised ?? 0;
      data['Plans'] = response.noOfFarmingPlansCreated ?? 0;
      data['Ads'] = response.noOfAdsPublished ?? 0;
      data['Bank'] = response.noOfFarmPlansBankApproved ?? 0;
      data['BID'] = response.noOfBidAccepted ?? 0;
      data['Payment'] = response.noOfBuyerPaymentReceived ?? 0;
    }

    data.refresh();
    isLoading.value = false;
  }

  List<String> get labels => data.keys.toList();
  List<int> get values => data.values.toList();
}
