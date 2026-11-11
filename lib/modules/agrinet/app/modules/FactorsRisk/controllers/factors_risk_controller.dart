import 'dart:convert';

import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_alert_dialogue.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/model/common/option.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class FactorsRiskController extends GetxController {
  Rx<FarmingPlanResponse?> response = FarmingPlanResponse().obs;
  Rx<FactorsRiskSubmitRequest?> request = FactorsRiskSubmitRequest().obs;
  final RxBool isLoading = false.obs;

  // final crops = <CropSuggestionModel>[].obs;
  late FarmArguments args;

  // Selected values - what AgDropdownField uses (friendlyType or type)
  final climaticConditions = Rxn<Option>();
  final soilFertility = Rxn<Option>();
  final seedQuality = Rxn<Option>();
  final fertilizersUsage = Rxn<Option>();
  final chemicalsUsage = Rxn<Option>();
  final irrigationMethod = Rxn<Option>();
  final irrigationCoverage = Rxn<Option>();
  final agroEquipmentAvail = Rxn<Option>();
  final accessToCredit = Rxn<Option>();
  final labourAvailability = Rxn<Option>();
  final forecastedYield = Rxn<Option>();
  final electricitySupply = Rxn<Option>();
  final storageAvailability = Rxn<Option>();
  final transportationAvail = Rxn<Option>();
  final harvestMarketing = Rxn<Option>();

  List<SelectOptionList> get optionLists =>
      response.value?.selectOptionList ?? [];

  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments is FarmArguments) {
      args = Get.arguments;
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
        response.value = farmData;
        getFarmData();
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
      "farmingPlanId": args.farmingPlanId,
      "screenId": "FACTORS_RISKS",
    };
  }

  Future<void> getFarmData() async {
    final risks = response.value?.farmingGrowthFactorsRisks;
    if (risks == null) return;

    climaticConditions.value = _findMatchingOption(
      'CLIMATE_CONDITION',
      risks.climaticConditions,
    );

    soilFertility.value = _findMatchingOption(
      'SOIL_FERTILITY',
      risks.soilFertility,
    );

    seedQuality.value = _findMatchingOption('SEED_QUALITY', risks.seedQuality);

    fertilizersUsage.value = _findMatchingOption(
      'FERTILIZERS_USAGE',
      risks.fertilizersUsage,
    );

    chemicalsUsage.value = _findMatchingOption(
      'CHEMICALS_USAGE',
      risks.pestiOrChemUsage,
    );

    irrigationMethod.value = _findMatchingOption(
      'IRRIGATION_METHOD',
      risks.irrigationMethod,
    );

    irrigationCoverage.value = _findMatchingOption(
      'IRRIGATION_COVERAGE',
      risks.irrigationCoverage,
    );

    agroEquipmentAvail.value = _findMatchingOption(
      'AGRO_EQUIPMNT_AVAILABLE',
      risks.agroEquipmentAvail,
    );

    accessToCredit.value = _findMatchingOption(
      'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
      risks.accessToCredit,
    );

    labourAvailability.value = _findMatchingOption(
      'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
      risks.labourAvailability,
    );

    forecastedYield.value = _findMatchingOption(
      'FORECASTED_YIELD',
      risks.forecastedYield,
    );

    electricitySupply.value = _findMatchingOption(
      'ELECTRICITY_SUPPLY',
      risks.electricitySupply,
    );

    storageAvailability.value = _findMatchingOption(
      'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
      risks.storageAvailability,
    );

    transportationAvail.value = _findMatchingOption(
      'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
      risks.transportationAvail,
    );

    harvestMarketing.value = _findMatchingOption(
      'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
      risks.harvestMarketing,
    );
  }

  Option? _findMatchingOption(String key, Option? apiOption) {
    if (apiOption == null || apiOption.type == null) return null;

    final list = optionLists.firstWhere(
      (e) => e.key == key,
      orElse: () => SelectOptionList(key: key, options: []),
    );

    final options = list.options ?? [];

    return options.firstWhere(
      (o) => o.type?.toUpperCase() == apiOption.type?.toUpperCase(),
    );
  }

  /// For a given key (e.g. 'SEED_QUALITY'), return dropdown items as List<String>
  List<Option> getOptions(String key) {
    final list = optionLists.firstWhere(
      (e) => e.key == key,
      orElse: () => SelectOptionList(key: key, options: []),
    );

    return list.options ?? [];
  }

  /// Find Option model by selected friendlyType/type string
  Option? getOptionByFriendlyName(String key, String? selected) {
    if (selected == null) return null;

    final list = optionLists.firstWhere(
      (e) => e.key == key,
      orElse: () => SelectOptionList(key: key, options: []),
    );

    final options = list.options ?? [];
    return options.firstWhere(
      (o) => o.friendlyType == selected || o.type == selected,
      orElse: () => Option(type: selected, friendlyType: selected),
    );
  }

  Future<void> onSaveAndContinue() async {
    if (!_validateSelections()) {
      return;
    }
    request.value?.reqSecureKey = '${UserPrefs.user?.userId}';
    request.value?.farmingPlanId = args.farmingPlanId;
    request.value?.screenId = 'FACTORS_RISKS';
    request.value?.farmingGrowthFactorsRisks = FarmingGrowthFactorsRisks(
      climaticConditions: climaticConditions.value,
      soilFertility: soilFertility.value,
      seedQuality: seedQuality.value,
      fertilizersUsage: fertilizersUsage.value,
      pestiOrChemUsage: chemicalsUsage.value,
      irrigationMethod: irrigationMethod.value,
      irrigationCoverage: irrigationCoverage.value,
      agroEquipmentAvail: agroEquipmentAvail.value,
      accessToCredit: accessToCredit.value,
      labourAvailability: labourAvailability.value,
      forecastedYield: forecastedYield.value,
      electricitySupply: electricitySupply.value,
      storageAvailability: storageAvailability.value,
      transportationAvail: transportationAvail.value,
      harvestMarketing: harvestMarketing.value,
    );

    final body = request.toJson();
    removeId(body);
    print(jsonEncode(body));
    try {
      isLoading(true);

      // Get group list first
      final farmData = await FarmPlanService.submitFactors(formData: body);
      if (farmData?.chMessage?.isError == false) {
        AgAlertDialog.show(
          title: 'Alert',
          message: farmData?.chMessage?.message ?? '',
          onOk: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading(false);
    }
  }

  void removeId(dynamic data) {
    if (data is Map) {
      data.remove('id'); // remove id if exists
      data.values.forEach(removeId);
    } else if (data is List) {
      data.forEach(removeId);
    }
  }

  bool _validateSelections() {
    final fields = {
      "Climatic Conditions": climaticConditions.value,
      "Soil Fertility": soilFertility.value,
      "Seed Quality": seedQuality.value,
      "Fertilizers Usage": fertilizersUsage.value,
      "Pesticides / Chemicals Usage": chemicalsUsage.value,
      "Irrigation Method": irrigationMethod.value,
      "Irrigation Coverage": irrigationCoverage.value,
      "Agro Equipment Availability": agroEquipmentAvail.value,
      "Access to Credit": accessToCredit.value,
      "Labour Availability": labourAvailability.value,
      "Forecasted Yield": forecastedYield.value,
      "Electricity Supply": electricitySupply.value,
      "Storage Availability": storageAvailability.value,
      "Transportation Availability": transportationAvail.value,
      "Harvest & Marketing": harvestMarketing.value,
    };

    for (final entry in fields.entries) {
      if (entry.value == null) {
        agSnackbar(title: 'Alert', msg: 'Please select ${entry.key}.');
        return false;
      }
    }

    return true;
  }
}

class FactorsRiskSubmitRequest {
  String? reqSecureKey;
  String? farmingPlanId;
  String? screenId;
  FarmingGrowthFactorsRisks? farmingGrowthFactorsRisks;

  FactorsRiskSubmitRequest({
    this.reqSecureKey,
    this.farmingPlanId,
    this.screenId,
    this.farmingGrowthFactorsRisks,
  });

  Map<String, dynamic> toJson() {
    return {
      "reqSecureKey": reqSecureKey,
      "farmingGrowthFactorsRisks": farmingGrowthFactorsRisks?.toJson(),
      "farmingPlanId": farmingPlanId,
      "screenId": screenId,
    };
  }
}
