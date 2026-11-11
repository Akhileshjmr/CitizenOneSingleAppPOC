import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_alert_dialogue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class YieldDetailsController extends GetxController {
  //TODO: Implement YieldDetailsController

  Rx<FarmingPlanResponse?> yieldDetails = FarmingPlanResponse().obs;
  final RxBool isLoading = false.obs;

  late FarmArguments args;

  @override
  void onInit() {
    if (Get.arguments is FarmArguments) {
      args = Get.arguments;
      loadFarmData();
    }
    super.onInit();
  }

  void onYieldChanged(int index, String value) {
    final data = yieldDetails.value;
    if (data == null) return;

    data.yieldDet?[index].yieldkgOracre.value = value;
  }

  void onYieldValueChanged(int index, String value) {
    final data = yieldDetails.value;
    if (data == null) return;

    data.yieldDet?[index].yieldValue.value = value;
  }

  void toggleVerify(int index) {
    final data = yieldDetails.value;
    if (data == null) return;

    data.yieldDet?[index].valueGiven.toggle();
  }

  Map<String, dynamic> buildRequest() {
    final data = yieldDetails.value!;
    return {
      'reqSecureKey': '${UserPrefs.user?.userId}',
      'farmingPlanId': data.farmingPlanId,
      'screenId': 'YIELD_DETAILS',
      'yieldDet': data.yieldDet?.map((e) => e.toJson()).toList(),
    };
  }

  Future<void> submit() async {
    final req = buildRequest();
    debugPrint('REQUEST: $req');
    try {
      isLoading.value = true;
      final farmData = await FarmPlanService.submitFactors(formData: req);
      if (farmData?.chMessage?.isError == false) {
        AgAlertDialog.show(
          title: "Alert",
          message: farmData?.chMessage?.message ?? '',
          onOk: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFarmData() async {
    try {
      isLoading.value = true;

      // Get group list first
      final groupList = await FarmPlanService.fetchGroupFarmList(
        reqSecureKey: '${UserPrefs.user?.userId}',
        screenId: 'YIELD_DETAILS',
        farmingPlanId: args.farmingPlanId, // or from args
      );
      yieldDetails.value = groupList;
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
