import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/model/loan/PersonalLoan/PLSubmitResp.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_features_list.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';
import '../../../data/remote/provider/personal_loan/pl_bank_detils.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/ag_constants.dart';

class PlHomeScreenController extends GetxController {
  /// ---------------------- SCROLL ----------------------

  final ScrollController scrollController = ScrollController();

  /// ---------------------- DATA ----------------------

  final RxList<PlBankDetils> homeBankList = <PlBankDetils>[].obs;
  final RxList<PlBankDetils> compareBankList = <PlBankDetils>[].obs;

  Rx<PlBankDetils> selectedBank = PlBankDetils().obs;

  final RxList<PersonalLoanFeaturesList> homeBankFeatures =
      <PersonalLoanFeaturesList>[].obs;

  final RxList<TabItems> tabItems = <TabItems>[].obs;

  /// ---------------------- LOADING FLAGS ----------------------

  /// Existing (DO NOT REMOVE – used by BaseScreen)
  final RxBool isLoading = false.obs;

  /// New Individual Loaders
  final RxBool isBankListLoading = false.obs;
  final RxBool isApplyLoading = false.obs;
  final RxBool isFeaturesLoading = false.obs;

  /// Initial full screen loading (first load only)
  bool get isInitialLoading => isBankListLoading.value;

  /// Optional combined loader
  bool get isAnyLoading =>
      isBankListLoading.value ||
      isApplyLoading.value ||
      isFeaturesLoading.value;

  /// ---------------------- UI STATE ----------------------

  final RxInt isTabVisiblePosition = (-1).obs;
  RxList<int> openTabs = <int>[].obs;

  final RxInt selectedIndex = (-1).obs;

  RxBool showSingleBankOnly = false.obs;
  RxInt selectedBankIndex = 0.obs;

  /// Store keys for scroll
  final Map<int, GlobalKey> itemKeys = {};

  void scrollToIndex(int index) {
    final context = itemKeys[index]?.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration.zero,
        alignment: 0.2,
      );
    }
  }

  /// ---------------------- STATIC DATA ----------------------

  final List<String> filterList = const ['Feature', 'Salary', 'Loan Amount'];

  /// ---------------------- API CALLS ----------------------

  Future<void> getBankList() async {
    try {
      isBankListLoading(true);

      List<PlBankDetils?> result = await PersonalLoanService.getHomeBankList();

      if (AgConstants.bankCode.isNotEmpty) {
        result =
            result
                .where((e) => e?.agencyBankCode == AgConstants.bankCode)
                .toList();
      }

      homeBankList.assignAll(result.cast<PlBankDetils>());
      compareBankList.clear();
    } catch (e) {
      _showWarning('Something went wrong');
    } finally {
      isBankListLoading(false);
    }
  }

  Future<void> getFilteredBankList() async {
    try {
      isBankListLoading(true);

      List<PlBankDetils?> result =
          await PersonalLoanService.getHomeFilteredBankList();

      if (AgConstants.bankCode.isNotEmpty) {
        result =
            result
                .where((e) => e?.agencyBankCode == AgConstants.bankCode)
                .toList();
      }

      homeBankList.assignAll(result.cast<PlBankDetils>());
    } catch (e) {
      _showWarning('Something went wrong');
    } finally {
      isBankListLoading(false);
    }
  }

  Future<void> applyBank(PlBankDetils bank) async {
    try {
      isApplyLoading(true);
      isLoading(true); // keep existing behavior

      selectedBank(bank);
      LocalStore.bankId(bank.bankId.toString());
      final res = await PersonalLoanService.plApplyLoanCheck();

      if (!(res?.chMessage?.isError ?? true)) {
        await Get.toNamed(Routes.LOAN_DETAILS);
      } else {
        appSnackbar(
          message: res?.chMessage?.message ?? 'Unable to process request',
          snackbarState: SnackbarState.warning,
        );
      }
    } finally {
      isApplyLoading(false);
      isLoading(false);
    }
  }

  Future<void> getFeatures(String productCode) async {
    try {
      isFeaturesLoading(true);

      final result = await PersonalLoanService.getFeatures(productCode);

      homeBankFeatures.assignAll(result.cast<PersonalLoanFeaturesList>());

      _buildTabItems();
    } finally {
      isFeaturesLoading(false);
    }
  }

  Future<void> checkBank() async {
    try {
      isLoading(true);

      final PlSubmitResp? res = await PersonalLoanService.plApplyLoanCheck();

      if (res?.chMessage?.message == 'Request processed successfully.') {
        await Get.toNamed<void>(Routes.LOAN_DETAILS);
      } else {
        _showWarning(res?.chMessage?.message ?? 'Something went wrong');
      }
    } finally {
      isLoading(false);
    }
  }

  /// ---------------------- TAB BUILDER ----------------------

  void _buildTabItems() {
    if (homeBankFeatures.isEmpty) return;

    final items =
        homeBankFeatures
            .take(3)
            .map(
              (feature) => TabItems(
                title: feature.feature ?? '',
                subTitle: feature.featureVal ?? '',
              ),
            )
            .toList();

    tabItems.assignAll(items);

    openTabs.value = List.generate(tabItems.length, (index) => index);
  }

  /// ---------------------- COMPARE ----------------------

  void toggleCompare(PlBankDetils product) {
    if (compareBankList.contains(product)) {
      compareBankList.remove(product);
      return;
    }

    if (compareBankList.length >= 2) {
      _showWarning('You cannot compare more than two products');
      return;
    }

    compareBankList.add(product);
  }

  void clearCompareList() {
    compareBankList.clear();
  }

  /// ---------------------- FILTER ----------------------

  Future<void> handleFilter(int index) async {
    if (index == 0) {
      final result = await Get.toNamed(Routes.PL_FEATURES_FILTER);

      if (result == true) {
        await getFilteredBankList();
        compareBankList.clear();
      }
    } else {
      appSnackbar(message: "Coming soon...");
    }
  }

  /// ---------------------- HELPERS ----------------------

  void _showSuccess(String message) {
    appSnackbar(message: message, snackbarState: SnackbarState.success);
  }

  void _showWarning(String message) {
    appSnackbar(message: message, snackbarState: SnackbarState.warning);
  }

  /// ---------------------- LIFECYCLE ----------------------

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      isLoading(true);

      /// Run both APIs in parallel
      await getBankList();
    } finally {
      isLoading(false);
    }
  }
}

/// ---------------------- TAB MODEL ----------------------

class TabItems {
  final String title;
  final String subTitle;

  TabItems({required this.title, required this.subTitle});
}
