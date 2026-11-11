import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/model/loan/PersonalLoan/pl_emi_calculator/EmiCalculator.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';

class PlCheckEmiController extends GetxController {
  // Loan EMI value;
  RxDouble loanEMI = 1000.0.obs;

  // Loan EMI value;
  RxDouble interestRate = 1.0.obs;

  // Loan EMI value;
  RxDouble loanTenure = 1.0.obs;

  // total payment;
  RxDouble totalPayment = 0.0.obs;

  // loan emi after calculation;
  RxDouble finalLoanEmi = 0.0.obs;

  // total interest
  RxDouble totalInterest = 0.0.obs;

  ///
  Rx<EmiCalculator> emiCalculatorResp = EmiCalculator().obs;

  final loanEmiController = TextEditingController();
  final interestController = TextEditingController();
  final tenureController = TextEditingController();

  final count = 0.obs;
  @override
  void onInit() {
    loanEmiController.text = loanEMI.value.toInt().toString();
    interestController.text = interestRate.value.toString();
    tenureController.text = loanTenure.value.toInt().toString();
    getCalculatedEmi(loanEMI.value, interestRate.value, loanTenure.value);
    super.onInit();
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

  void emiCalculator(double slideEmi, double slideRate, double slideTenure) {
    double rateOfInterest = 0.0;
    double totalInt = 0.0;
    double totalPay = 0.0;

    rateOfInterest = 1 / (12 * 100);

    double emiBasedOnLoanReq =
        (slideEmi *
            rateOfInterest *
            pow(1 + rateOfInterest, slideTenure * 12)) /
        (pow(1 + rateOfInterest, slideTenure * 12) - 1);

    totalInt = emiBasedOnLoanReq * slideTenure * 12 - slideEmi;
    totalPay = slideEmi + totalInt;

    finalLoanEmi.value = emiBasedOnLoanReq.round() * 100.0 / 100.0;
    totalInterest.value = totalInt.round() * 100.0 / 100.0;
    totalPayment.value = totalPay * 100.0.round() / 100.0;
    totalInterest.refresh();
    finalLoanEmi.refresh();
    totalPayment.refresh();
  }

  Future<void> getCalculatedEmi(
    double slideEmi,
    double slideRate,
    double slideTenure,
  ) async {
    final Map<String, dynamic> formData = <String, dynamic>{
      'loanRequestAmount': slideEmi.toInt(),
      'maxTenure': slideTenure.toInt(),
      'rateOfInterest': slideRate.toInt(),
    };
    emiCalculatorResp(
      await PersonalLoanService.calculateEMi(formData: formData),
    );
    totalPayment(emiCalculatorResp().totalPayment?.toDouble() ?? 0);
    totalInterest(emiCalculatorResp().totalInterest?.toDouble() ?? 0);
    finalLoanEmi(emiCalculatorResp().loanEmi?.toDouble() ?? 0);
  }

  String formatAmount(num value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }
}
