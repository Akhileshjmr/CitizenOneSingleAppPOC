import 'package:get/get.dart';

import '../../../data/model/loan/PersonalLoan/Banks.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';

class PlFilterProductController extends GetxController {
  /// List of provider list
  final RxList<Banks> bankList = <Banks>[].obs;

  /// List of selected Bnaks ID
  final RxList<String> selectedBankIds = <String>[].obs;

  /// Api loading
  final RxBool isLoading = true.obs;

  final count = 0.obs;
  @override
  void onInit() {
    getProviderList();
    super.onInit();

    if (Get.arguments != 0) {
      selectedBankIds(Get.arguments);
    }
  }

  /// get filter bank list
  Future<void> getProviderList() async {
    try {
      isLoading(true);
      bankList((await PersonalLoanService.getFilterBankList()).cast<Banks>());
    } finally {
      isLoading(false);
    }
  }
}
