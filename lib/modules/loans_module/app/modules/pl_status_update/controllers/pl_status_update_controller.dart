import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/common/ch_message.dart';
import '../../../data/model/loan/PersonalLoan/PersonalLoanList.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';

class PlStatusUpdateController extends GetxController {
  final Rx<PersonalLoanList?> plStatus = PersonalLoanList().obs;

  TextEditingController eligibleAmtController = TextEditingController();
  TextEditingController requestLoanAmtController = TextEditingController();

  /// Api loading
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    plStatus(Get.arguments);
    eligibleAmtController.text =
        plStatus.value?.plEligibilityAmt.toString() ?? '';
    requestLoanAmtController.text =
        plStatus.value?.plEligibilityAmt.toString() ?? '';
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onApproveSubmit(dynamic data) async {
    // formKey.currentState!.save();
    isLoading(true);
    final Map<String, dynamic> formData = data;

    print(formData.toString());

    try {
      final ChMessage res = await PersonalLoanService.AcceptPeroanlDetails(
        formData: formData,
      );

      if (res.type == 'SUCCESS') {
        Get.back();
      } else {
        appSnackbar(
          message: res.message.toString() ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } finally {
      isLoading(false);
    }
  }
}
