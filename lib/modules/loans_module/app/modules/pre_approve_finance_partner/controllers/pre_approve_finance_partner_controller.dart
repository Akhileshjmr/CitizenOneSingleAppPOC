import 'package:get/get.dart';

import '../../../data/model/loan/PreApprove/preApproveBankList/PreBankListResp.dart';
import '../../../data/remote/provider/loan/pre_approve_loan_service.dart';

class PreApproveFinancePartnerController extends GetxController {
  Rx<PreBankListResp> bankList = PreBankListResp().obs;

  RxBool isLoading = false.obs;

  final count = 0.obs;

  String filterval = '';
  String args = '';

  @override
  void onInit() {
    filterval = Get.arguments[0];
    args = Get.arguments[1];
    fetchBankList(filterval);
    super.onInit();
  }

  Future<void> fetchBankList(String filter) async {
    isLoading(true);
    try {
      PreBankListResp? resp = await PreApproveLoanService.getPreApproveFinance(
        filter,
      );
      bankList(resp);
    } finally {
      isLoading(false);
    }
  }
}
