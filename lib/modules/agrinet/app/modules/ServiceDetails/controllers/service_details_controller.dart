import 'package:get/get.dart';

import '../../../data/model/farmPlan/ServiceResp.dart';
import '../../../data/provider/FarmPlanService.dart';

class ServiceDetailsController extends GetxController {
  //TODO: Implement ServiceDetailsController

  Rx<ServiceReq?> service = ServiceReq().obs;
  Rx<ServiceResponse?> list = ServiceResponse().obs;
  RxBool isLoading = false.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      print(Get.arguments);
      final ServiceReq? response = Get.arguments as ServiceReq;
      service.value = response;
      fetchData();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;


  /// Fetch Service Request data
  Future<void> fetchData() async {
    try {

      isLoading.value = true;

      // Get group list first
      final formData = _createFormDataFromResponse();
      final farmData = await FarmPlanService.serviceDetails(formData: formData);
      list.value = farmData;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDataFromResponse() {
    return {"requestDet":{},"requestGenDet":{},"srNumber":service.value?.srNumber};
  }
}
