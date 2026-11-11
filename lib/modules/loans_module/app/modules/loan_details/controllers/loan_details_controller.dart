import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/common/ch_message.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/loan/PersonalLoan/FormData/LoanDetails.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';
import '../../../routes/app_pages.dart';

class LoanDetailsController extends GetxController {
  /// If the form is submitting or not
  final RxBool isLoading = false.obs;

  final GlobalKey<FormBuilderState> loanFormKey = GlobalKey<FormBuilderState>();

  TextEditingController loanPurposeController = TextEditingController();
  TextEditingController loanAmtController = TextEditingController();
  TextEditingController tenureController = TextEditingController();

  @override
  void onInit() {
    getLoanData();
    super.onInit();
  }

  @override
  void refresh() {
    getLoanData();
    super.refresh();
  }

  final String? Function(String?) loanPurposeValidators =
      FormBuilderValidators.compose(<String? Function(String?)>[
        FormBuilderValidators.required(errorText: 'Please enter loan purpose'),
      ]);

  final String? Function(String?) loanAmtValidators =
      FormBuilderValidators.compose(<String? Function(String?)>[
        FormBuilderValidators.required(errorText: 'Please enter loan amount'),
      ]);

  final String? Function(String?) tenureValidators =
      FormBuilderValidators.compose(<String? Function(String?)>[
        FormBuilderValidators.required(errorText: 'Please enter loan tenure'),
      ]);

  /// get loan details data
  Future<void> getLoanData() async {
    try {
      isLoading(true);
      LoanDetails? resp = await PersonalLoanService.getLoanDetails();
      loanAmtController.text = LocalStore.loanAmount().toString();
      if (resp?.tenure.toString() == '0') {
        tenureController.text = '';
      } else {
        tenureController.text = (resp?.tenure ?? '').toString();
      }
      loanPurposeController.text = resp?.purposeOfLoan ?? '';
    } finally {
      isLoading(false);
    }
  }

  /// save loan details data
  Future<void> onSubmit() async {
    if (loanFormKey.currentState?.saveAndValidate() ?? false) {
      isLoading(true);
      final Map<String, dynamic> formData = <String, dynamic>{
        "customerDet": {
          "loanDetails": {
            "purposeOfLoan": loanPurposeController.text.toString() ?? '',
            "tenure": tenureController.text.toString() ?? '',
            "loanAmount": loanAmtController.text.toString() ?? '',
          },
        },
        "filterVal": "PROFILE",
        "isDraft": true,
        "isFinance": true,
        "reqSecureKey": UserProvider.currentUser?.addiParams[0] ?? '',
        "addiParams": ["LOAN_DETAILS"],
      };
      try {
        final ChMessage res = await PersonalLoanService.submitLoanDetails(
          formData: formData,
        );
        if (res.type == 'SUCCESS') {
          // appSnackbar(message: 'updated successfully',
          //   snackbarState: SnackbarState.success,
          // );
          if (LocalStore.editString() == 'Review') {
            LocalStore.editString('');
            Navigator.pop(Get.context!, true);
          } else {
            await Get.toNamed<void>(
              Routes.PERSONAL_INFO,
              arguments: LimitArguments(LimitMode: 'Personal'),
            );
          }
        } else {
          appSnackbar(
            message: res.message ?? '',
            snackbarState: SnackbarState.success,
          );
        }
      } finally {
        isLoading(false);
      }
    }
  }
}
