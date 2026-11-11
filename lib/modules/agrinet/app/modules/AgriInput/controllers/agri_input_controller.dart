import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_alert_dialogue.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:get/get.dart';

import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class AgriInputController extends GetxController {
  Rx<FarmingPlanResponse?> inputs = FarmingPlanResponse().obs;
  final RxBool isLoading = false.obs;

  late FarmArguments args;
  final enableEdit = false.obs;
  final isSaving = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    if (Get.arguments is FarmArguments) {
      args = Get.arguments;
    }
    await loadFarmData();

    // Dummy data – replace with API data later
    // inputs.assignAll([
    //   AgriInputItem(
    //     category: 'Crop\nSolution',
    //     productName: 'Ethrel\nGrowth\nPromoter',
    //     unitPrice: 'PER HOUR',
    //     estimatedQuantity: '--',
    //   ),
    //   AgriInputItem(
    //     category: 'Transport',
    //     productName: 'Eicher Pro\n1059XP',
    //     unitPrice: 'PER DAY',
    //     estimatedQuantity: '--',
    //   ),
    //   AgriInputItem(
    //     category: 'Storage',
    //     productName: 'Ema Estate\nWarehouse',
    //     unitPrice: 'PER KM',
    //     estimatedQuantity: '--',
    //   ),
    //   AgriInputItem(
    //     category: 'Transport',
    //     productName: 'Eicher Pro\n1059XP',
    //     unitPrice: 'PER DAY',
    //     estimatedQuantity: '--',
    //   ),
    // ]);
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
        inputs.value = farmData;
      }
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDataFromResponse() {
    return {"farmingPlanId": args.farmingPlanId, "screenId": "AGRI_INPUT_EST"};
  }

  void onUpdateCropMaintenance() {
    if (!enableEdit.value) {
      enableEdit.value = true;
      return;
    }

    submitAllEstimates();
  }

  Future<void> submitAllEstimates() async {
    final list = inputs.value?.agriInputEst ?? [];

    final missing = list.any(
      (e) =>
          e.estQuantity == null ||
          e.estQuantity.toString().trim().isEmpty ||
          e.estQuantity == '--',
    );

    if (missing) {
      agSnackbar(
        title: "Missing Data",
        msg: "Please enter quantity for all items",
      );
      return;
    }

    final body = createRequestBody(list);

    final farmData = await FarmPlanService.submitAgriInput(formData: body);

    if (farmData?.chMessage?.isError == false) {
      enableEdit.value = false;
      AgAlertDialog.show(
        title: "Success",
        message: farmData?.chMessage?.message ?? '',
        onOk: Get.back,
      );
    }
  }

  void saveEstimate({
    required AgriInputEst? item,
    required String quantity,
    String? remarks,
  }) {
    if (item == null) return;

    item.estQuantity = quantity;

    if (remarks != null) {
      item.comments = remarks;
    }

    inputs.refresh();
    Get.back();
  }

  Map<String, dynamic> createRequestBody(List<AgriInputEst>? agri) {
    return {
      "agriInputEst": agri?.map((e) => e.toJson()).toList() ?? [],
      "farmingPlanId": args.farmingPlanId,
      "screenId": "AGRI_INPUT_EST",
    };
  }
}
