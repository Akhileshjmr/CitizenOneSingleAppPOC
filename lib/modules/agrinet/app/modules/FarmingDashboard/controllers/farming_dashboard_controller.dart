import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_alert_dialogue.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:get/get.dart';

import '../../../components/ui/CustomConfirmationDialog.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/model/farmPlan/FarmPlansResp.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/ag_png_image.dart';
import '../../FarmPlans/controllers/farm_plans_controller.dart';
import '../../home/views/MenuItemModel.dart';
import '../bindings/farming_dashboard_binding.dart';

class FarmingDashboardController extends GetxController {
  Rx<FarmingPlanResponse?> landDetails = FarmingPlanResponse().obs;
  late AgriFramdet plan;

  RxBool isLoading = false.obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is AgriFramdet) {
      plan = Get.arguments as AgriFramdet;
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

  final menuItems =
      <MenuItemModel>[
        MenuItemModel(
          title: 'SHG',
          image: PngImage.shgImg,
          route: Routes.SHG_DETAILS,
        ),
        MenuItemModel(
          title: 'Land Details',
          image: PngImage.landDetailsImg,
          route: Routes.LAND_DETAILS,
        ),
        MenuItemModel(
          title: 'Soil Assessment',
          image: PngImage.soilAssesmentImg,
          route: Routes.SOIL_MAPS,
        ),
        MenuItemModel(
          title: 'Crop Choices',
          image: PngImage.cropSuggestionImg,
          route: Routes.CROP_SUGGESTION,
        ),
        MenuItemModel(
          title: 'Factors and Risks',
          image: PngImage.risksImg,
          route: Routes.FACTORS_RISK,
        ),
        MenuItemModel(
          title: 'Yield Details',
          image: PngImage.yieldDetailsImg,
          route: Routes.YIELD_DETAILS,
        ),
        MenuItemModel(
          title: 'Schedule Plan',
          image: PngImage.schCalImg,
          route: Routes.EVENT_DISPLAY,
        ),
        MenuItemModel(
          title: 'Agri Inputs',
          image: PngImage.agriInputsImg,
          route: Routes.AGRI_INPUT,
        ),
        MenuItemModel(
          title: 'Funding Request',
          image: PngImage.financeRequestsImg,
          route: Routes.FINANCE_REQUEST,
        ),
        MenuItemModel(
          title: 'Crop Insurance',
          image: PngImage.cropInsuranceImg,
          route: Routes.CROP_INSURANCE,
        ),
        MenuItemModel(
          title: 'Service Request',
          image: PngImage.serviceRequestImg,
          route: Routes.SERVICE_REQUEST,
        ),
      ].obs;

  void onMenuTap(MenuItemModel item) {
    if (item.route != null && item.route!.isNotEmpty) {
      // if (item.route == Routes.SHG_DETAILS || item.route == Routes.LAND_DETAILS ){
      Get.toNamed(
        item.route!,
        arguments: FarmArguments(
          farmingPlanId: plan.planId ?? '',
          farmingStatus: plan.appStatus ?? '',
        ),
      );
      // }else {
      //   Get.toNamed(item.route!);
      // }
    }
  }

  void onStartWorkflowTap() {
    // handle Start Work Flow button tap
    // e.g. Get.toNamed(Routes.START_WORKFLOW);
    Get.dialog(
      CustomConfirmationDialog(
        title: "Workflow Initiation",
        message: "Are you sure to start work flow?",
        cancelText: "Cancel",
        confirmText: "Start Work Flow",
        onConfirm: () async {
          // API / logic
          Get.back();
          await onAddLandTap();
        },
      ),
      barrierDismissible: false,
    );
  }

  Future<void> onAddLandTap() async {
    try {
      isLoading(true);
      final formData = _createFormDataFromResponse();
      final farmData = await FarmPlanService.GroupFarmDeatilsList(
        formData: formData,
      );
      if (farmData?.chMessage?.isError == false) {
        await Get.find<FarmPlansController>().fetchPlan();
        AgAlertDialog.show(
          title: "Workflow Initiation",
          message: farmData?.chMessage?.message ?? '',
          buttonText: "Ok",
          onOk: () {
            Get.close(1);
          },
        );
      } else {
        agSnackbar(
          title: 'Error',
          msg:
              farmData?.chMessage?.message ??
              'Something went wrong. Please try again later.',
        );
      }
    } finally {
      isLoading(false);
    }
  }

  Map<String, dynamic> _createFormDataFromResponse() {
    return {
      "reqSecureKey": "${UserPrefs.user?.userId}",
      "farmingPlanId": plan.planId,
      "screenId": "START_WORKFLOW",
    };
  }
}
