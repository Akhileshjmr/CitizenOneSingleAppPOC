import 'package:get/get.dart';

import '../../../data/model/farmPlan/ServiceResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class ServiceRequestController extends GetxController {
  //TODO: Implement ServiceRequestController

  final count = 0.obs;
  Rx<ServiceResponse?> list = ServiceResponse().obs;
  late FarmArguments args;

  // For loading state
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is FarmArguments) {
      args = Get.arguments;
      fetchData();
    }
  }

  /// Fetch Service Request data
  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      isLoading.value = true;

      // Get group list first
      final formData = _createFormDataFromResponse();
      final farmData = await FarmPlanService.serviceList(formData: formData);
      list.value = farmData;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDataFromResponse() {
    return {
      "requestDet": {},
      "requestGenDet": {},
      "srNumber": args.farmingPlanId,
    };
  }
}
