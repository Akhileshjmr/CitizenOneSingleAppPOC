import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PreApprove/preApproveBankList/BankListForLoanList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PreApprove/preApproveBankList/PreBankListResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/auto_loan/AutoLoanHistoryResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/auto_loan/Order.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/real_estate_provider.dart';

import '../../../data/remote/provider/preApproveLoanService.dart';

class RealEstateLoanHistoryController extends GetxController {
  //TODO: Implement RealEstateLoanHistoryController

  /// Api loading
  final RxBool isLoading = false.obs;

  RxList<Order> loanList = <Order>[].obs;
  // final RxList<PersonalLoanList?> plList = <PersonalLoanList?>[].obs;

  RxList<BankListForLoanList?>? bankList = <BankListForLoanList>[].obs;
  String filterval = '/homeloan';

  final count = 0.obs;

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
    getHomeLoan();
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

  Future<void> getHomeLoan() async {
    isLoading(true);
    AutoLoanHistoryResp? resp = await RealEstateProvider.getHomeLoanHistory();
    loanList(resp?.order ?? []);
    isLoading(false);
  }

  Future<void> fetchBankList(String filter) async {
    isLoading(true);
    try {
      PreBankListResp? resp = await preApproveLoanService.getPreApproveFinance(
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
