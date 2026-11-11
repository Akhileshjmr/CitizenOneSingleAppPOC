import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';

import '../../../data/local/store/local_store.dart';
import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';
import '../../../routes/app_pages.dart';

class IncomeTypeController extends GetxController {
  /// Form key
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// Selected income type
  final RxString incomeType = ''.obs;

  /// API loading state
  final RxBool isLoading = false.obs;

  /// Continue button action
  Future<void> onContinue() async {
    if (incomeType.value.isEmpty) {
      appSnackbar(message: 'Please select income type');
      return;
    }

    if (isLoading.value) return; // Prevent double tap

    await _updatePersonalLoan();
  }

  Future<void> _updatePersonalLoan() async {
    try {
      isLoading.value = true;

      final loanAmount = LocalStore.loanAmount();
      LocalStore.category(incomeType.value);

      final LimitFnaSubResp? response = await PersonalLoanService.getApplyPL(
        'INCOME_TYPE_ENTERED',
        incomeType.value,
        loanAmount,
      );

      if (response?.chMessage?.isError == false) {
        await Get.toNamed(Routes.MONTHLY_INCOME);
      } else {
        appSnackbar(
          message: response?.chMessage?.message ?? 'Something went wrong',
          snackbarState: SnackbarState.warning,
        );
      }
    } catch (e) {
      appSnackbar(
        message: 'Unexpected error occurred',
        snackbarState: SnackbarState.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
