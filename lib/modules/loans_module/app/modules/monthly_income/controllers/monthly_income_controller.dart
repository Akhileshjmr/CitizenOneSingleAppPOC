import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/local/store/local_store.dart';
import '../../../data/model/employee/employee_details.dart';
import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';
import '../../../data/remote/provider/personal_loan/professional_list_service.dart';
import '../../../routes/app_pages.dart';

class MonthlyIncomeController extends GetxController {
  /// Form key
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Employee profile data
  final Rxn<EmployeeDetails> employeeDetails = Rxn<EmployeeDetails>();

  /// Income controller
  final TextEditingController monthlyIncomeController = TextEditingController();

  // -------------------------------
  // Validators
  // -------------------------------

  final String? Function(String?) incomeValidator =
      FormBuilderValidators.compose([
        FormBuilderValidators.required(
          errorText: 'Please enter your monthly income',
        ),
        FormBuilderValidators.min(
          5000,
          errorText: 'Minimum salary should be ₹5,000',
        ),
        FormBuilderValidators.max(
          20000000,
          errorText: 'Maximum salary should be ₹2,00,00,000',
        ),
      ]);

  @override
  void onInit() {
    super.onInit();
    _fetchProfessionData();
  }

  @override
  void onClose() {
    monthlyIncomeController.dispose();
    super.onClose();
  }

  // -------------------------------
  // Continue Action
  // -------------------------------

  Future<void> onContinue() async {
    if (isLoading.value) return;

    final isValid = formKey.currentState?.saveAndValidate() ?? false;

    if (!isValid) return;

    final income = int.tryParse(monthlyIncomeController.text.trim());

    if (income == null) return;

    await _resetPreferences();
    LocalStore.monthlySalary(income);

    await _updatePersonalLoan(
      remark: income.toString(),
      action: 'INCOME_ENTERED',
      amount: LocalStore.loanAmount(),
    );
  }

  // -------------------------------
  // API Calls
  // -------------------------------

  Future<void> _updatePersonalLoan({
    required String remark,
    required String action,
    required int? amount,
  }) async {
    try {
      isLoading.value = true;

      final LimitFnaSubResp? response = await PersonalLoanService.getApplyPL(
        action,
        remark,
        amount,
      );

      if (response?.chMessage?.isError == false) {
        Get.toNamed(Routes.PL_HOME_SCREEN);
      }
    } catch (_) {
      // Optionally show snackbar here
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchProfessionData() async {
    try {
      isLoading.value = true;

      final EmployeeDetails? response =
          await ProfessionalListService.getProfessionDetails(
            ApiEndPoints.getProfileForms,
          );

      employeeDetails.value = response;

      /*final income = response?.netMonthlyIncome?.toInt();

      if (income != null) {
        monthlyIncomeController.text = income.toString();
      }*/
    } catch (_) {
      // Optional: handle error
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------
  // Local Helpers
  // -------------------------------

  Future<void> _resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('features', []);
    await prefs.setStringList('bankIds', []);
  }
}
