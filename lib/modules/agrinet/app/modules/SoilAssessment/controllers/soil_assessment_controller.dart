import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/model/farmPlan/SoilAssessment.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class SoilAssessmentController extends GetxController {
  //TODO: Implement SoilAssessmentController
  Rx<soilAssessmentResp?> soilDetails = soilAssessmentResp().obs;

  late soilArguments args;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is soilArguments) {
      args = Get.arguments;
    }
    loadFarmData();
  }

  void onDownloadReport() {
    // TODO: trigger report download
  }

  Future<void> loadFarmData() async {
    try {
      // isLoading.value = true;

      final formData = _createFormDataFromResponse();
      final farmData = await FarmPlanService.SoilAssement(formData: formData);

      soilDetails.value = farmData;
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      // isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDataFromResponse() {
    return {
      "reqSecureKey": "${UserPrefs.user?.userId}",
      "farmingPlanId": args.farmingPlanId,
      "latitude": "${args.latitude}",
      "longitude": "${args.longitude}",
      "screenId": "SOIL_ASSESSMENT",
    };
  }
}
