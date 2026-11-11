import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/loan/PersonalLoan/PLCompareProductResp.dart';
import '../../../data/model/loan/PersonalLoan/PLSubmitResp.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';
import '../../../data/remote/provider/personal_loan/pl_bank_detils.dart';
import '../../../routes/app_pages.dart';

class PlCompareProductController extends GetxController {
  /// List of campare bank
  final RxList<PlBankDetils> compareBankList = <PlBankDetils>[].obs;

  final Rx<PlCompareProductResp> compareProdcuts = PlCompareProductResp().obs;

  final count = 0.obs;

  /// Api loading
  final RxBool isLoading = false.obs;

  /// get compare product data
  Future<void> getCompareData() async {
    isLoading(true);

    PlCompareProductResp resp = await PersonalLoanService.getCompareDate(
      compareBankList[0].productCode ?? '',
      compareBankList[1].productCode ?? '',
    );

    compareProdcuts(resp);
    isLoading(false);
  }

  Future<void> checkBank() async {
    isLoading(true);

    try {
      PlSubmitResp? res = await PersonalLoanService.plApplyLoanCheck();

      if (res?.chMessage?.message == 'Request processed successfully.') {
        await Get.toNamed<void>(Routes.LOAN_DETAILS);
      } else {
        appSnackbar(
          message: res?.chMessage?.message.toString() ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    if (Get.arguments is List) {
      final list = Get.arguments as List;
      compareBankList(list.cast<PlBankDetils>());
      getCompareData();
    }

    super.onInit();
  }
}
