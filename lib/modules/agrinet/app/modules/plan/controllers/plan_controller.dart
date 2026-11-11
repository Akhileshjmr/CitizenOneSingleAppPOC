// lib/app/modules/plan/controllers/plan_controller.dart
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/common/option.dart';
import '../../../data/model/plan/group_member.dart';
import '../../../data/provider/plan_service.dart';
import '../../../routes/app_pages.dart';

class PlanController extends GetxController {
  final planNameCtrl = TextEditingController();
  final planDescCtrl = TextEditingController();

  final groupList = <Option>[].obs;
  final selectedGroup = Rxn<Option>();

  final members = <GroupMember>[].obs;

  final isLoading = false.obs;

  final _service = PlanService();

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadGroupList();
  }

  Future<void> loadGroupList() async {
    try {
      isLoading(true);
      final resp = await _service.fetchGroupFarmerList();
      if (resp != null && resp.selectOptionList != null) {
        final opt = resp.selectOptionList?.firstWhereOrNull(
          (e) => e.key == 'GROUP_LIST',
        );
        groupList.assignAll(opt?.options ?? []);
      }
    } finally {
      isLoading(false);
    }
  }

  void updateGroup(Option? option) {
    if (option == null) return;
    selectedGroup.value = option;
    loadGroupMembers(option);
  }

  Future<void> loadGroupMembers(Option selectedGrp) async {
    try {
      isLoading(true);
      final list = await _service.fetchGroupMembers(selectedGrp);
      members.assignAll(list);
    } finally {
      isLoading(false);
    }
  }

  Future<void> savePlan() async {
    try {
      isLoading(true);

      // validation...
      if (planNameCtrl.text.isEmpty) {
        agSnackbar(title: "Alert", msg: "Enter Farm Plan Name");
        return;
      }
      if (planDescCtrl.text.isEmpty) {
        agSnackbar(title: "Alert", msg: "Enter Farm Plan Description");
        return;
      }
      if (selectedGroup.value == null) {
        agSnackbar(title: "Alert", msg: "Please select a Group");
        return;
      }

      // API CALL
      final resp = await PlanService().savePlan(
        planName: planNameCtrl.text.trim(),
        planDesc: planDescCtrl.text.trim(),
        group: selectedGroup.value!,
        members: members,
      );

      if (resp == null) return;

      // Extract exact backend message
      final msg = resp.chMessage?.message ?? "";

      // Navigate to success screen
      Get.toNamed(
        Routes.SUCCESS_INFO,
        arguments: {
          "title": "Info",
          "message": msg,
          "onOk": () => Get.offAllNamed(Routes.HOME),
        },
      );

      // Clear form
      members.clear();
      selectedGroup.value = null;
      planNameCtrl.clear();
      planDescCtrl.clear();
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    planNameCtrl.dispose();
    planDescCtrl.dispose();
    for (final m in members) {
      m.contributionCtrl.dispose();
    }
    super.onClose();
  }
}
