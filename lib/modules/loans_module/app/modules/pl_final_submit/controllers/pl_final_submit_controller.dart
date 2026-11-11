import 'package:get/get.dart';

import '../../../data/local/store/local_store.dart';
import '../../../data/model/loan/PersonalLoan/FinalLoanSubmitResp.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';

class PlFinalSubmitController extends GetxController {
  Rx<FinalLoanSubmitResp> resp = FinalLoanSubmitResp().obs;

  /// Api loading
  final RxBool isLoading = true.obs;

  /// Error State
  final RxBool hasError = false.obs;
  final RxString errorTitle = ''.obs;
  final RxString errorMessage = ''.obs;

  String tenure = '';
  String remark = '';

  Future<void> checkBank(String arg) async {
    isLoading(true);

    try {
      final response =
      await PersonalLoanService.finalLoanSumbit(arg, remark);

      resp(response);

      final chMessage = resp.value.chMessage;

      if (chMessage?.isError == true ||
          chMessage?.type?.toUpperCase() == 'FAIL') {
        hasError(true);
        errorTitle(chMessage?.subject ?? 'Error');
        errorMessage(
          chMessage?.message ?? 'Something went wrong. Please try again.',
        );
      } else if (chMessage?.message ==
          'Request processed successfully.') {
        LocalStore.loanRefId('');
        hasError(false);
      } else {
        hasError(true);
        errorTitle('Error');
        errorMessage(
          chMessage?.message ?? 'Something went wrong. Please try again.',
        );
      }
    } catch (e) {
      hasError(true);
      errorTitle('Error');
      errorMessage('Unable to process your request. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    if (Get.arguments[0] is String) {
      tenure = Get.arguments[0];
    }

    if (Get.arguments[1] is String) {
      remark = Get.arguments[1];
    }

    checkBank(tenure);

    super.onInit();
  }
}