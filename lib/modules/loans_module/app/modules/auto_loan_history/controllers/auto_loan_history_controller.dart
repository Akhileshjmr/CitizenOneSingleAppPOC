import 'package:get/get.dart';

import '../../../data/model/loan/PreApprove/preApproveBankList/BankListForLoanList.dart';
import '../../../data/model/loan/PreApprove/preApproveBankList/PreBankListResp.dart';
import '../../../data/model/loan/auto_loan/AutoLoanHistoryResp.dart';
import '../../../data/model/loan/auto_loan/Order.dart';
import '../../../data/remote/provider/loan/auto_service.dart';
import '../../../data/remote/provider/loan/pre_approve_loan_service.dart';

class AutoLoanHistoryController extends GetxController {
  /// Api loading
  final RxBool isLoading = false.obs;

  RxList<Order> loanList = <Order>[].obs;
  RxList<BankListForLoanList?>? bankList = <BankListForLoanList>[].obs;

  final count = 0.obs;
  String filterval = '/vehicleloan';

  ///
  RxBool isFromOrderScreen = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is bool) {
        isFromOrderScreen(Get.arguments as bool);
      }
    }
    getAutoLoan();
    fetchBankList(filterval);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> getAutoLoan() async {
    isLoading(true);
    AutoLoanHistoryResp? resp = await AutoService.getAutoLoanHistory();
    loanList(resp?.order ?? []);
    isLoading(false);
  }

  Future<void> fetchBankList(String filter) async {
    isLoading(true);
    try {
      PreBankListResp? resp = await PreApproveLoanService.getPreApproveFinance(
        filter,
      );
      List<BankListForLoanList> bankListData = [];
      for (var i = 0; i < (resp.bankListForLoanList?.length ?? 0); i += 1) {
        if ((resp.bankListForLoanList?[i].appliedForLoan ?? false) == true) {
          bankListData.add(
            resp.bankListForLoanList?[i] ?? BankListForLoanList(),
          );
        }
      }
      bankList!(bankListData);
    } finally {
      isLoading(false);
    }
  }
}
