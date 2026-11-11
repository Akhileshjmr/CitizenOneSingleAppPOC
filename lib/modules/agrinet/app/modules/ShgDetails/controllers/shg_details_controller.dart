import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class ShgDetailsController extends GetxController {
  //TODO: Implement ShgDetailsController

  Rx<FarmingPlanResponse?> members = FarmingPlanResponse().obs;
  Rx<FarmingPlanResponse?> membersDetails = FarmingPlanResponse().obs;
  late FarmArguments args;
  final groupList = [].obs;
  final RxBool isLoading = false.obs;

  final count = 0.obs;

  @override
  // void onInit() {
  //   super.onInit();
  // }
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    farmPlanNameCtrl.dispose();
    farmPlanDescCtrl.dispose();
    super.onClose();
  }

  void increment() => count.value++;
  final farmPlanNameCtrl = TextEditingController();
  final farmPlanDescCtrl = TextEditingController();

  final selectedGroup = ''.obs;

  // final members = <ShgMemberModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    farmPlanNameCtrl.text = "Rice group test plan";
    farmPlanDescCtrl.text = "";
    if (Get.arguments is FarmArguments) {
      args = Get.arguments;
      // if (args.farmingPlanId != null) {
      //   farmerPlanId.value = args.farmingPlanId;
      //   status.value = args.farmingStatus;
      // } else {
      //   farmerPlanId.value = '';
      // }
    }
    await loadFarmData();
    // members.addAll([
    //   ShgMemberModel(name: "Rice group test plan", availableLand: 0, contribution: 100.0),
    //   ShgMemberModel(name: "C  c", availableLand: 0, contribution: 50.0),
    // ]);
  }

  // void onChangeGroup(String? value) {
  //   if (value != null) selectedGroup.value = value;
  // }

  void onClosePressed() {
    Get.back();
  }

  Future<void> loadFarmData() async {
    try {
      isLoading.value = true;

      // Get group list first
      final groupList = await FarmPlanService.fetchGroupFarmList(
        reqSecureKey: '${UserPrefs.user?.userId}',
        screenId: 'SHG_DETAILS',
        farmingPlanId: args.farmingPlanId, // or from args
      );
      membersDetails.value = groupList;
      selectedGroup.value = groupList?.groupId?.friendlyType ?? '';
      farmPlanNameCtrl.text = groupList?.name ?? '';
      farmPlanDescCtrl.text = groupList?.desc ?? '';
      // Use group list to get detailed farm info
      final formData = _createFormDataFromResponse(groupList!);
      final farmData = await FarmPlanService.GroupFarmDeatilsList(
        formData: formData,
      );

      members.value = farmData;
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDataFromResponse(
    FarmingPlanResponse response,
  ) {
    return {
      "chMessage": {
        "code": "SUCCESS",
        "dispType": "ALERT",
        "message": "Request processed successfully.",
        "subject": "Alert",
        "type": "SUCCESS",
      },
      "reqSecureKey": "${UserPrefs.user?.userId}",
      "farmingPlanId": response.farmingPlanId,
      "groupId": response.groupId?.toJson(), // Assuming toJson() method exists
      "screenId": "SHG_DETAILS",
      "selectOptionList":
          response.selectOptionList?.map((e) => e.toJson()).toList(),
      "status": response.status,
    };
  }
}

// shg_member_model.dart
class ShgMemberModel {
  final String name;
  final double availableLand;
  final double contribution;

  ShgMemberModel({
    required this.name,
    required this.availableLand,
    required this.contribution,
  });
}
