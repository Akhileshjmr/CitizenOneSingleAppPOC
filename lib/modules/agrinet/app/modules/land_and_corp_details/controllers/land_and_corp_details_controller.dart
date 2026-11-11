import 'package:citizenone_app/modules/agrinet/app/data/model/user/main_response.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_snackbar.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/model/common/option.dart';
import '../../../data/provider/onboard_service.dart';
import '../../../routes/app_pages.dart';
import '../../add_farmer/controllers/add_farmer_controller.dart';

class LandAndCorpDetailsController extends GetxController {
  RxString village = "".obs;
  RxString cropName = "".obs;

  RxInt docId = 0.obs;

  RxBool isLoading = false.obs;

  RxInt area = 0.obs;
  RxInt irrigatedPerc = 0.obs;
  RxInt farmValue = 0.obs;
  RxInt cultLandArea = 0.obs; //saleValue

  Rx<Option?> landType = Rx<Option?>(null);
  Rx<Option?> sourceOfIrrigation = Rx<Option?>(null);
  Rx<Option?> season = Rx<Option?>(null);
  Rx<Option?> areaUnit = Rx<Option?>(null);

  List<Option> landTypeList = [];
  List<Option> sourceOfIrrigationList = [];
  List<Option> seasonList = [];
  List<Option> areaUnitList = [];
  RxBool showForm = true.obs;

  RxList<Map<String, dynamic>> landRecordList = <Map<String, dynamic>>[].obs;

  final ownedOption = Option(id: 1, type: "Owned", friendlyType: "Owned Area");
  final leasedOption = Option(
    id: 2,
    type: "Leased",
    friendlyType: "Leased Area",
  );

  @override
  void onInit() {
    readMainResponse();
    super.onInit();
  }

  void addRecord() {
    if (cultLandArea.value > area.value) {
      return _showError(
        "Cultivated land area cannot be greater than total area",
      );
    }
    if (areaUnit.value == null) {
      return _showError("Please select area unit");
    }
    if (village.value.isEmpty) return _showError("Please enter village name");
    if (area.value <= 0) return _showError("Please enter valid area");
    if (landType.value == null) return _showError("Please select land type");
    if (irrigatedPerc.value <= 0) return _showError("Please enter irrigated %");
    if (sourceOfIrrigation.value == null) {
      return _showError("Please select irrigation source");
    }
    if (farmValue.value <= 0) return _showError("Please enter farm value");
    if (season.value == null) return _showError("Please select season");
    if (cropName.value.isEmpty) return _showError("Please enter crop name");
    if (cultLandArea.value <= 0) {
      return _showError("Please enter cultivated area");
    }

    landRecordList.add({
      "areaUnit": areaUnit.value?.toJson(),
      "village": village.value,
      "area": area.value,
      "cropName": cropName.value,
      "farmValue": farmValue.value,
      "irrigatedPerc": irrigatedPerc.value,
      "cultLandArea": cultLandArea.value,

      // Nested data
      "landType": landType.value?.friendlyType,
      "sourceOfIrrigation": sourceOfIrrigation.value?.friendlyType,
      "sourceType": sourceOfIrrigation.value?.type,
      "season": season.value?.friendlyType,
      "seasonType": season.value?.type,
    });

    showForm.value = false;
    clearForm();
  }

  Map<String, dynamic> buildRequestObject() {
    return {
      "filterVal": UserPrefs.user?.userId ?? '',
      "id": docId.value,
      "landHolding":
          landRecordList.map((item) {
            return {
              "areaUnit": {"type": item["areaUnit"]?["type"]},
              "village": item["village"],
              "area": item["area"],
              "cropName": item["cropName"],
              "farmValue": item["farmValue"],
              "irrigatedPerc": item["irrigatedPerc"],
              "saleValue": item["cultLandArea"],

              "landType": {"friendlyType": item["landType"]},

              "sourceOfIrrigation": {
                "friendlyType": item["sourceOfIrrigation"],
                "type": item["sourceType"],
              },

              "season": {
                "friendlyType": item["season"],
                "type": item["seasonType"],
              },
            };
          }).toList(),

      "mobileScreen": "LAND_CROP_DETAIL",
    };
  }

  void _showError(String msg) {
    agSnackbar(title: "Missing Information", msg: msg);
  }

  void clearForm() {
    village.value = "";
    area.value = 0;
    landType.value = null;
    irrigatedPerc.value = 0;
    sourceOfIrrigation.value = null;
    farmValue.value = 0;
    season.value = null;
    cropName.value = "";
    cultLandArea.value = 0;
    areaUnit.value = null;
  }

  void readMainResponse() {
    final controller = Get.find<AddFarmerController>();
    docId.value = controller.docId.value;

    sourceOfIrrigationList =
        controller.mainResponse.value?.getOptionsByKey('IRRIGATION_TYPE') ?? [];
    seasonList =
        controller.mainResponse.value?.getOptionsByKey('SEASON_TYPE') ?? [];
    areaUnitList =
        controller.mainResponse.value?.getOptionsByKey('AREA_UNIT') ?? [];
  }

  void removeLandRecord(int index) {
    landRecordList.removeAt(index);
  }

  Future<void> saveLandDetails(String requestType) async {
    try {
      if (landRecordList.isEmpty) {
        return agSnackbar(
          title: "Missing Information",
          msg: "Please add at least one land holding",
        );
      }

      isLoading(true);

      final response = await OnboardService.saveFarmerData(
        request: buildRequestObject(),
      );

      if (!(response.message?.isError ?? false)) {
        if (requestType == 'saveAsDraft') {
          Get.offAllNamed(Routes.HOME);
          agSnackbar(title: "Success", msg: "Land details saved as draft");
        } else {
          Get.toNamed(Routes.CROP_YIELD);
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
