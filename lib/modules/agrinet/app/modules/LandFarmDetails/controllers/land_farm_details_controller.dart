import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_alert_dialogue.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:get/get.dart';

import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../../utils/ag_list_bottom_sheets.dart';
import '../../LandDetails/controllers/land_details_controller.dart';

class LandFarmDetailsController extends GetxController {
  /// All land details
  RxList<LandDetail> landDetails = <LandDetail>[].obs;

  /// Selected group
  Rx<GroupDetail?> groupDetails = Rx<GroupDetail?>(null);

  List<GroupDetail> groupList = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    readGroupDetails();
  }

  /// Checkbox toggle
  void toggleLandChecked(int index, bool? value) {
    landDetails[index].isChecked = value ?? false;
    landDetails.refresh();
  }

  /// SAVE
  Future<void> onSave() async {
    try {
      /// Check invalid cases
      final invalidLand = landDetails.firstWhereOrNull((land) {
        final isChecked = land.isChecked ?? false;
        final contribution = land.contribution ?? 0;

        /// checkbox selected but contribution missing
        if (isChecked && contribution <= 0) {
          return true;
        }

        /// contribution entered but checkbox not selected
        if (!isChecked && contribution > 0) {
          return true;
        }

        return false;
      });

      if (invalidLand != null) {
        agSnackbar(
          title: "Invalid Entry!",
          msg:
              "If land is selected contribution must be entered and vice versa.",
        );
        return;
      }

      /// Also ensure at least one valid item
      final hasValidLand = landDetails.any(
        (l) => (l.isChecked ?? false) && (l.contribution ?? 0) > 0,
      );

      if (!hasValidLand) {
        agSnackbar(
          title: "Missing information!",
          msg: "Please select at least one land and enter contribution.",
        );
        return;
      }

      isLoading(true);

      final formData = _createFormDataFromResponse();

      final response = await FarmPlanService.SaveGroupFarmDeatils(
        formData: formData,
      );

      if (response?.chMessage?.isError == false) {
        await Get.find<LandDetailsController>().loadFarmData();

        AgAlertDialog.show(
          title: 'Alert',
          message: response?.chMessage?.message ?? '',
          onOk: () => Get.back(),
        );
      } else {
        agSnackbar(
          title: "Error",
          msg: response?.chMessage?.message ?? "Something went wrong",
        );
      }
    } finally {
      isLoading(false);
    }
  }

  /// REQUEST BODY
  Map<String, dynamic> _createFormDataFromResponse() {
    return {
      "chMessage": {"dispType": "ALERT", "subject": "Alert"},
      "contribution": landDetails.first.contribution ?? 0.0,
      "custId": {
        "id": groupDetails.value?.custId?.id,
        "type": groupDetails.value?.custId?.type,
        "friendlyType": groupDetails.value?.custId?.friendlyType,
      },
      "isChecked": true,
      "custName": groupDetails.value?.custName,
      "landDetails":
          landDetails.map((land) {
            return {
              "landId": land.landId,
              "village": land.village,
              "ownedArea": land.ownedArea,
              "leasedArea": land.leasedArea,
              "irrigatedPerc": land.irrigatedPerc,
              "farmValue": land.farmValue,
              "sourceOfIrrigation": land.sourceOfIrrigation,
              "isChecked": land.isChecked,
            };
          }).toList(),

      "mobileNo":
          Get.find<LandDetailsController>().landDetails.value?.farmingPlanId ??
          '',
    };
  }

  /// Read arguments
  void readGroupDetails() {
    if (Get.arguments is! Map) return;

    final args = Get.arguments as Map;

    groupList = (args["groupDetails"] as List<GroupDetail>?) ?? [];

    final index = args["index"] ?? 0;

    if (groupList.isNotEmpty && index < groupList.length) {
      selectGroup(groupList[index]);
    }
  }

  /// Select group
  void selectGroup(GroupDetail group) {
    groupDetails.value = group;
    landDetails.assignAll(group.landDetails ?? []);
  }

  /// Popup
  void showMemberPopup() {
    final list = groupList;

    AGListBottomSheet.show(
      items: list,

      getName: (e) => e.custName ?? '',

      title: "Select Farmer",

      emptyMessage: "No Farmer available",

      onSelected: (group, index) {
        selectGroup(group);
      },
    );
  }
}
