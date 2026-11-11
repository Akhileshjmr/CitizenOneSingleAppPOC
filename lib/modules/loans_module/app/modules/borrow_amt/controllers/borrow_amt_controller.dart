import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/personal_loan/personal_loan_service.dart';

import '../../../data/local/store/local_store.dart';
import '../../../routes/app_pages.dart';

class BorrowAmtController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  final RxBool isLoading = false.obs;
  TextEditingController amountController = TextEditingController();

  /// Validator
  final amountValidator = FormBuilderValidators.compose([
    FormBuilderValidators.required(errorText: 'Please enter a loan amount.'),
    FormBuilderValidators.min(
      50000,
      errorText: 'Loan amount must be greater than 49,999.',
    ),
    FormBuilderValidators.max(
      10000000,
      errorText: 'Loan amount must be less than 10,000,000.',
    ),
  ]);

  @override
  void onInit() {
    super.onInit();
    /*_updatePersonalLoan(
      remark: 'Shown interest in Personal Loan',
      action: 'INTERESTED',
      amount: 0,
    );*/
  }

  Future<void> onContinue() async {
    if (!(formKey.currentState?.saveAndValidate() ?? false)) return;

    final amount = int.parse(amountController.text);

    LocalStore.loanAmount(amount);

    await _updatePersonalLoan(
      remark: 'Loan amount entered',
      action: 'LOAN_AMOUNT_ENTERED',
      amount: amount,
      navigateNext: true,
    );
  }

  /// Single API handler
  Future<void> _updatePersonalLoan({
    required String remark,
    required String action,
    required int amount,
    bool navigateNext = false,
  }) async {
    try {
      isLoading.value = true;

      final resp = await PersonalLoanService.getApplyPL(action, remark, amount);

      if (resp?.chMessage?.isError == false && navigateNext) {
        Get.toNamed(Routes.INCOME_TYPE);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
