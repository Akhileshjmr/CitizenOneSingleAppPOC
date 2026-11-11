import 'package:get/get.dart';

import '../../../data/model/loan/PreApprove/preApproveHistory/PRLoanHistoryResp.dart';
import '../../../data/remote/provider/loan/pre_approve_loan_service.dart';

class PRUploanHistoryController extends GetxController {
  Rx<PrLoanHistoryResp> loanData = PrLoanHistoryResp().obs;

  RxBool isLoading = true.obs;

  String bank_id = '';
  String filterval_id = '';

  @override
  Future<void> onInit() async {
    bank_id = Get.arguments[1];
    filterval_id = Get.arguments[0];
    await fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      PrLoanHistoryResp? resp = await PreApproveLoanService.getPreApproveLoan(
        bank_id,
        filterval_id,
      );
      if (resp.loanList != null) {
        loanData(resp);
      }
    } finally {
      isLoading(false);
    }
  }
}
