import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../components/utils/CommonUtilities.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/model/common/option.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class FinanceRequestController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();

  /// API response wrapper
  final response = Rxn<FarmingPlanResponse>();

  late FarmArguments args;

  // Dropdown Option Lists (NON-nullable items) - Use RxList<Option?> instead
  final loanPurposeList = RxList<Option?>([]);
  final productNameList = RxList<Option?>([]);
  final schemeList = RxList<Option?>([]);
  final homeBranchList = RxList<Option?>([]);
  final collateralPoolCodeList = RxList<Option?>([]);

  // Selected values (nullable)
  final selectedLoanPurpose = Rx<Option?>(null);
  final selectedProduct = Rx<Option?>(null);
  final selectedScheme = Rx<Option?>(null);
  final homeBranch = Rx<Option?>(null);
  final collateralPoolCode = Rx<Option?>(null);

  // Govt scheme radio toggle
  final isGovtScheme = false.obs;

  // Loader
  final isLoading = false.obs;

  // Document path
  final collateralDocPath = RxnString();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is FarmArguments) {
      args = Get.arguments;
      loadFarmData();
    }
  }

  Future<void> loadFarmData() async {
    try {
      isLoading.value = true;

      final result = await FarmPlanService.fetchGroupFarmList(
        reqSecureKey: '${UserPrefs.user?.userId}',
        screenId: 'FINANCE_REQUEST',
        farmingPlanId: args.farmingPlanId,
      );

      response.value = result;

      parseSelectOptions(result);
    } catch (e) {
      debugPrint("Load Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Match selected Option with fresh list (avoid initialValue errors)
  Option? matchOption(Option? selected, List<Option?> list) {
    if (selected == null) return null;

    for (final e in list) {
      if (e == null) continue;

      if (selected.id != null && e.id != null && selected.id == e.id) {
        return e;
      }
      if (e.type == selected.type && e.friendlyType == selected.friendlyType) {
        return e;
      }
    }

    return null;
  }

  void parseSelectOptions(FarmingPlanResponse? resp) {
    final selects = resp?.selectOptionList;
    if (selects == null) return;

    loanPurposeList.clear();
    productNameList.clear();
    schemeList.clear();

    for (final item in selects) {
      if (item == null) continue;

      final key = item.key;
      final raw = item.options ?? [];

      // Convert all raw items into Option safely, filtering out nulls
      final List<Option> options =
          raw
              .map<Option?>((opt) => _parseOption(opt))
              .whereType<Option>()
              .toList();

      switch (key) {
        case "LOAN_PURPOSE":
          loanPurposeList.assignAll(options);
          selectedLoanPurpose.value = matchOption(
            selectedLoanPurpose.value,
            loanPurposeList,
          );
          break;

        case "AGRI_PRODUCT":
          productNameList.assignAll(options);
          selectedProduct.value = matchOption(
            selectedProduct.value,
            productNameList,
          );
          break;

        case "CLTRL_POOL":
          collateralPoolCodeList.assignAll(options);
          collateralPoolCode.value = matchOption(
            collateralPoolCode.value,
            collateralPoolCodeList,
          );
          break;
      }
    }
  }

  Option? _parseOption(dynamic opt) {
    try {
      if (opt is Option) {
        return opt;
      }

      if (opt is Map<String, dynamic>) {
        return Option.fromJson(opt);
      }

      if (opt is Map) {
        // Convert any Map type to Map<String, dynamic>
        return Option.fromJson(
          Map<String, dynamic>.from(opt as Map<dynamic, dynamic>),
        );
      }

      return null;
    } catch (e) {
      debugPrint("Error parsing option: $e");
      return null;
    }
  }

  /// Document Picker
  void pickCollateralDoc() {
    CommonUtilities().openImagePicker(
      Get.context!,
      (file) {
        collateralDocPath.value = file.path;
      },
      (picked) {
        collateralDocPath.value = picked.path;
      },
    );
  }

  /// Save Button
  Future<void> onSave() async {
    try {
      isLoading(true);
      final form = formKey.currentState;

      if (!(form?.saveAndValidate() ?? false)) return;

      final values = form!.value;

      final req = createFinanceRequestBody(values);
      final farmData = await FarmPlanService.submitAgriInput(formData: req);
      if (farmData?.chMessage?.isError == false) {
        AgAlertDialog.show(
          title: 'Alert',
          message: farmData?.chMessage?.message ?? '',
          onOk: () => Get.back(),
        );
      }

      debugPrint("FINANCE REQUEST JSON => $req");
    } finally {
      isLoading(false);
    }
  }

  /// Build request body
  Map<String, dynamic> createFinanceRequestBody(Map<String, dynamic> values) {
    return {
      "reqSecureKey": "${UserPrefs.user?.userId}",
      "farmingPlanId": args.farmingPlanId,
      "financeRequest": {
        "distanceToBranchKms": values["distanceToBranch"],
        "durationMonths": values["duration"],
        "govScheme": isGovtScheme.value,
        "loanAmount": values["loanAmount"],
        "loanPurpose": optionToJsonNoId(selectedLoanPurpose.value),
        "product": optionToJsonNoId(selectedProduct.value),
        "purposeDesc": values["purposeDescription"],
        // "schemeName": optionToJsonNoId(selectedScheme.value),
        "schemeName": optionToJsonNoId(selectedProduct.value),
        "collateralPoolCode": optionToJsonNoId(collateralPoolCode.value),
      },
      "screenId": "FINANCE_REQUEST",
    };
  }

  Map<String, dynamic>? optionToJsonNoId(Option? opt) {
    if (opt == null) return null;

    return {"type": opt.type, "friendlyType": opt.friendlyType};
  }
}
