import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/ui/agShowDatePicker.dart';
import '../../../components/ui/ag_snackbar.dart';
import '../../../data/model/common/option.dart';
import '../../../data/provider/market_filter.dart';

class MarketFilterController extends GetxController {
  /// ---------------- DATE PICKERS ----------------
  RxString fromDate = "".obs;
  RxString toDate = "".obs;

  /// ---------------- LOADING ----------------
  RxBool isLoading = false.obs;

  /// ---------------- DROPDOWN SELECTIONS ----------------
  final selectedState = Rx<Option?>(null);
  final selectedCommodity = Rx<Option?>(null);

  /// ---------------- LISTS ----------------
  final states = <Option>[].obs;
  final commodities = <Option>[].obs;

  /// ---------------- COMPUTED LISTS (Strings only) ----------------
  /// ⚡ These prevent recomputation inside the UI
  List<String> get stateNames =>
      states.map((e) => e.friendlyType ?? "").toList();

  List<String> get commodityNames =>
      commodities.map((e) => e.friendlyType ?? "").toList();

  /// ---------------- SELECTED VALUE (String) ----------------
  String get selectedStateName => selectedState.value?.friendlyType ?? "";

  String get selectedCommodityName =>
      selectedCommodity.value?.friendlyType ?? "";

  @override
  void onInit() {
    fetchDropDownData();
    super.onInit();
  }

  /// ---------------- API CALL ----------------
  Future<void> fetchDropDownData() async {
    try {
      isLoading(true);

      final res = await MarketFilterService.getStateAndCommodities();

      if (res != null) {
        final userDraft = res;

        // Extract states
        states.value =
            userDraft.selectOptionList
                ?.firstWhere((item) => item.key == "states")
                .options ??
            [];

        // Extract commodities
        commodities.value =
            userDraft.selectOptionList
                ?.firstWhere((item) => item.key == "commodities")
                .options ??
            [];
      }
    } catch (e) {
      print("Error in fetchDropDownData: $e");
    } finally {
      isLoading(false);
    }
  }

  /// ---------------- UPDATE SELECTED STATE ----------------
  void updateSelectedState(String? name) {
    if (name == null) return;
    selectedState.value = states.firstWhereOrNull(
      (e) => e.friendlyType == name,
    );
  }

  /// ---------------- UPDATE SELECTED COMMODITY ----------------
  void updateSelectedCommodity(String? name) {
    if (name == null) return;
    selectedCommodity.value = commodities.firstWhereOrNull(
      (e) => e.friendlyType == name,
    );
  }

  /// ---------------- DATE PICKERS ----------------
  Future<void> pickFromDate() async {
    final picked = await ShowDatePickerHelper().pickDate(
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      fromDate.value = DateFormat('d-M-yyyy').format(picked);

      /// If To Date becomes invalid → reset it
      if (toDate.value.isNotEmpty) {
        final to = DateFormat('d-M-yyyy').parse(toDate.value);

        if (picked.isAfter(to)) {
          toDate.value = "";
        }
      }
    }
  }

  Future<void> pickToDate() async {
    DateTime firstAllowedDate = DateTime(2000);

    /// If From Date selected → restrict To Date
    if (fromDate.value.isNotEmpty) {
      firstAllowedDate = DateFormat('d-M-yyyy').parse(fromDate.value);
    }

    final picked = await ShowDatePickerHelper().pickDate(
      firstDate: firstAllowedDate,
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      toDate.value = DateFormat('d-M-yyyy').format(picked);
    }
  }

  /// ---------------- APPLY FILTERS ----------------
  void applyFilters() {
    // ---------------- VALIDATION ----------------

    if (fromDate.value.isEmpty) {
      agSnackbar(title: "Missing information", msg: "Please select From Date");
      return;
    }

    if (toDate.value.isEmpty) {
      agSnackbar(title: "Missing information", msg: "Please select To Date");
      return;
    }

    if (selectedState.value == null) {
      agSnackbar(title: "Missing information", msg: "Please select State");
      return;
    }

    /// Parse only after empty check
    final from = DateFormat('d-M-yyyy').parse(fromDate.value);
    final to = DateFormat('d-M-yyyy').parse(toDate.value);

    if (from.isAfter(to)) {
      agSnackbar(
        title: "Invalid Date",
        msg: "From Date cannot be greater than To Date",
      );
      return;
    }

    /// Navigate
    Get.toNamed(Routes.MARKET_PRICE);
  }
}
