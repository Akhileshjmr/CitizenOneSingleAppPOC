import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/ag_list_bottom_sheets.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class LandDetailsController extends GetxController {
  // ---------------- Observables ----------------

  final landDetails = Rxn<FarmingPlanResponse>();
  final farmDetails = Rxn<FarmingPlanResponse>();
  final isLoading = false.obs;

  late final FarmArguments args;

  // ---------------- LifeCycle ----------------

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is FarmArguments) {
      args = arguments;
      loadFarmData();
    } else {
      agSnackbar(title: "Error", msg: "Invalid navigation data");
    }
  }

  // ---------------- Common Loader ----------------

  Future<T?> _withLoader<T>(Future<T?> Function() task) async {
    try {
      isLoading.value = true;
      return await task();
    } catch (e) {
      debugPrint("Controller Error: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- Load Farm Data ----------------

  Future<void> loadFarmData() async {
    await _withLoader(() async {
      final response = await FarmPlanService.fetchGroupFarmList(
        reqSecureKey: UserPrefs.user?.userId?.toString() ?? '',
        screenId: 'LAND_DETAILS_DRAFT',
        farmingPlanId: args.farmingPlanId,
      );

      landDetails.value = response;
      return null;
    });
  }

  // ---------------- Add Land ----------------

  Future<void> onAddLandTap() async {
    if (landDetails.value == null) return;

    final formData = _createFormData();

    final response = await _withLoader(() async {
      return await FarmPlanService.GroupFarmDeatilsList(formData: formData);
    });

    if (response == null) return;

    farmDetails.value = response;

    if (response.chMessage?.isError == false) {
      showMemberBottomSheet(response);
    } else {
      agSnackbar(
        title: "Error",
        msg: response.chMessage?.message ?? "Something went wrong",
      );
    }
  }

  // ---------------- Bottom Sheet ----------------

  void showMemberBottomSheet(FarmingPlanResponse members) {
    final groupList = members.groupDetails ?? [];

    AGListBottomSheet.show(
      items: groupList,

      getName: (e) => e.custName ?? '',

      title: "Select Farmer",

      emptyMessage: "No Farmers available",

      onSelected: (member, index) {
        Get.toNamed(
          Routes.LAND_FARM_DETAILS,
          arguments: {"groupDetails": groupList, "index": index},
        );
      },
    );
  }

  Widget _dragHandle() {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // ---------------- Delete Land ----------------

  Future<void> deleteItem({
    required LandDetail land,
    required int groupIndex,
  }) async {
    await _withLoader(() async {
      final response = await FarmPlanService.deleteLandDetail(
        farmingPlanId: args.farmingPlanId,
        landDetails: land,
      );

      if (response?.chMessage?.isError == false) {
        landDetails.value?.groupDetails?[groupIndex].landDetails?.remove(land);

        landDetails.refresh();

        agSnackbar(title: "Success", msg: "Item removed successfully");
      } else {
        agSnackbar(
          title: "Warning",
          msg: "Failed to delete item",
          backgroundColor: AgColors.warning,
        );
      }

      return null;
    });
  }

  // ---------------- Save Farming Plan ----------------

  Future<FarmingPlanResponse?> saveFarmingPlan() async {
    return await _withLoader(() async {
      final body = _buildRequestBody();

      final response = await FarmPlanService.saveFarmingPlan(
        reqSecureKey: body["reqSecureKey"],
        screenId: body["screenId"],
        farmingPlanId: body["farmingPlanId"],
        groupDetails: body["groupDetails"],
      );

      if (response?.chMessage?.isError == false) {
        agSnackbar(title: "Success", msg: response?.chMessage?.message ?? '');
      } else {
        agSnackbar(title: "Warning", msg: "Save failed. Try again.");
      }

      return response;
    });
  }

  // ---------------- Request Body ----------------

  Map<String, dynamic> _buildRequestBody() {
    return {
      "farmingPlanId": args.farmingPlanId,
      "screenId": "LAND_DETAILS",
      "reqSecureKey": UserPrefs.user?.userId?.toString() ?? '',

      "groupDetails":
          landDetails.value?.groupDetails?.map((group) {
            return {
              "custId": group.custId?.toJson(),
              "custName": group.custName ?? '',
              "mobileNo": group.mobileNo ?? '',
              "uniqueId": group.uniqueId ?? '',
              "chMessage": group.chMessage?.toJson(),

              "landDetails":
                  group.landDetails?.map((land) {
                    return {
                      "landId": land.landId,
                      "ownedArea": land.ownedArea,
                      "village": land.village,
                    };
                  }).toList() ??
                  [],
            };
          }).toList() ??
          [],
    };
  }

  // ---------------- Form Data ----------------

  Map<String, dynamic> _createFormData() {
    return {
      "reqSecureKey": UserPrefs.user?.userId?.toString() ?? '',
      "farmingPlanId": args.farmingPlanId,
      "screenId": "LAND_DETAILS",
    };
  }
}
