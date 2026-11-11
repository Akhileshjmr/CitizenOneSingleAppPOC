import 'package:citizenone_app/modules/agrinet/app/data/model/user/main_response.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_snackbar.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/model/common/option.dart';
import '../../../data/provider/onboard_service.dart';
import '../../../routes/app_pages.dart';
import '../../add_farmer/controllers/add_farmer_controller.dart';

class CropYieldController extends GetxController {
  // Form fields
  Rx<Option?> selectedYear = Rx<Option?>(null);
  Rx<Option?> selectedSeason = Rx<Option?>(null);
  RxString cropName = "".obs;
  RxDouble yield = 0.0.obs;
  RxDouble yieldValue = 0.0.obs;

  // Lists
  List<Option> yearList = [];
  List<Option> seasonList = [];

  // UI State
  RxBool showForm = true.obs;
  RxBool isLoading = false.obs;

  RxInt docId = 0.obs;

  // Final records stored
  RxList<Map<String, dynamic>> yieldRecordList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    readMainResponse();
    super.onInit();
  }

  // ------------------ VALIDATION & ADD RECORD ------------------
  void addRecord() {
    if (selectedYear.value == null) return _showError("Please select year");
    if (selectedSeason.value == null) return _showError("Please select season");
    if (cropName.value.isEmpty) return _showError("Please enter crop name");
    if (yield.value <= 0) return _showError("Please enter yield");
    if (yieldValue.value <= 0) return _showError("Please enter yield value");

    yieldRecordList.add({
      "year": selectedYear.value!.friendlyType,
      "yearType": selectedYear.value!.type,
      "season": selectedSeason.value!.friendlyType,
      "seasonType": selectedSeason.value!.type,
      "cropName": cropName.value,
      "yield": yield.value,
      "yieldValue": yieldValue.value,
    });

    showForm.value = false;
    clearForm();
  }

  // ------------------ BUILD FINAL REQUEST OBJECT ------------------
  Map<String, dynamic> buildRequestObject() {
    return {
      "filterVal": UserPrefs.user?.userId ?? '',
      "id": docId.value,
      "mobileScreen": "YIELD_DETAILS",
      "yieldDetails":
          yieldRecordList.map((item) {
            return {
              "corpName": item["cropName"],
              "season": {
                "friendlyType": item["season"],
                "type": item["seasonType"],
              },
              "year": {"friendlyType": item["year"], "type": item["yearType"]},
              "yield": item["yield"],
              "yieldValue": item["yieldValue"],
            };
          }).toList(),
    };
  }

  // ------------------ SAVE API CALL ------------------
  Future<void> saveYieldDetails(String type) async {
    if (yieldRecordList.isEmpty) {
      return agSnackbar(
        title: "Missing Information",
        msg: "Please add at least one record",
      );
    }

    try {
      isLoading(true);
      final response = await OnboardService.saveFarmerData(
        request: buildRequestObject(),
      );

      if (!(response.message?.isError ?? false)) {
        agSnackbar(
          title: "Success",
          msg: "Farmer onboarding details saved successfully",
        );

        Get.offAllNamed(Routes.HOME);
      }
    } finally {
      isLoading(false);
    }
  }

  // ------------------ FORM HELPERS ------------------
  void clearForm() {
    selectedYear.value = null;
    selectedSeason.value = null;
    cropName.value = "";
    yield.value = 0;
    yieldValue.value = 0;
  }

  void removeRecord(int index) {
    yieldRecordList.removeAt(index);
  }

  void _showError(String msg) {
    agSnackbar(title: "Missing Information", msg: msg);
  }

  void readMainResponse() {
    final farmerCtrl = Get.find<AddFarmerController>();
    docId.value = farmerCtrl.docId.value;
    seasonList =
        farmerCtrl.mainResponse.value?.getOptionsByKey("SEASON_TYPE") ?? [];

    yearList = [
      Option(id: 5, type: "2014-2015", friendlyType: "2014-2015"),
      Option(id: 6, type: "2015-2016", friendlyType: "2015-2016"),
      Option(id: 7, type: "2016-2017", friendlyType: "2016-2017"),
    ];
  }
}
