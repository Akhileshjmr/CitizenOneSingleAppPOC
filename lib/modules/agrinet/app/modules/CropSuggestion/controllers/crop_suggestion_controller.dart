import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../../data/provider/crop_insurance_service.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class CropSuggestionController extends GetxController {
  //TODO: Implement CropSuggestionController

  Rx<FarmingPlanResponse?> crops = FarmingPlanResponse().obs;
  final RxBool isLoading = false.obs;

  // final crops = <CropSuggestionModel>[].obs;
  late FarmArguments args;

  final farmerPlanId = ''.obs;

  final count = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    if (Get.arguments is FarmArguments) {
      args = Get.arguments;
      if (args.farmingPlanId != null) {
        farmerPlanId.value = args.farmingPlanId;
      } else {
        farmerPlanId.value = '';
      }
    }
    await loadFarmData();
  }

  Future<void> loadFarmData() async {
    try {
      isLoading.value = true;

      // Get group list first
      final formData = _createFormDataFromResponse();
      final farmData = await FarmPlanService.GroupFarmDeatilsList(
        formData: formData,
      );
      if (farmData?.chMessage?.isError == false) {
        crops.value = farmData;
      }
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDataFromResponse() {
    return {
      "reqSecureKey": "${UserPrefs.user?.userId}",
      "farmingPlanId": farmerPlanId.value,
      "screenId": "CROP_SUGGESTION",
    };
  }

  void onSubmit() {
    final list = crops.value?.recommendedCrop ?? [];

    // Count selected items
    final selected = list.where((e) => e.recommended.value == true).toList();
    print(selected.first.cropName);

    if (selected.length != 2) {
      agSnackbar(
        title: 'Validation',
        msg: 'Please select exactly 2 crops as recommended.',
      );
      return;
    }
    submitFarmData(selected);
    // ✅ proceed with API call / next screen
    // submitFarmingPlan(selected);
  }

  Future<void> submitFarmData(List<RecommendedCrop>? data) async {
    try {
      isLoading.value = true;

      // Get group list first
      final formData = _createSubmitFormDataFromResponse(data);
      final response = await CropInsuranceService.saveCropInsurance(
        request: formData,
      );
      if (response?.chMessage?.isError == false) {
        await AgAlertDialog.show(
          title: "Alert",
          message: response?.chMessage?.message ?? '',
        );
        Get.back();
      }
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createSubmitFormDataFromResponse(
    List<RecommendedCrop>? crop,
  ) {
    return {
      "reqSecureKey": "${UserPrefs.user?.userId}",
      "farmingPlanId": farmerPlanId.value,
      "recommendedCrop": crop?.map((e) => e.toJson()).toList(),
      "screenId": "CROP_SUGGESTION",
    };
  }
}
