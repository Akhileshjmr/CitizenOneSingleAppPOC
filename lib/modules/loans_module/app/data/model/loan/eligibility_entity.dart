// To parse this JSON data, do
//
//     final eligibilityEntity = eligibilityEntityFromJson(jsonString);

import 'dart:convert';

EligibilityEntity eligibilityEntityFromJson(String str) =>
    EligibilityEntity.fromJson(json.decode(str));

String eligibilityEntityToJson(EligibilityEntity data) =>
    json.encode(data.toJson());

class EligibilityEntity {
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final dynamic value;
  final String? message;
  final bool? isEligible;
  final String? eligibility;
  final String? emiLoanRequest;
  final String? maxEligibleAmt;
  final String? maxEligibility;
  final String? tenure;
  final String? notEligibleMessage;

  final double? monthlyFixedSalary;
  final double? addiMonthlyIncome;
  final double? autoFinance;
  final double? personalFinance;
  final double? homeFinance;
  final double? otherInstallments;
  final double? creditCardLimit;

  EligibilityEntity({
    this.chMessage,
    this.urlDecision,
    this.value,
    this.message,
    this.eligibility,
    this.emiLoanRequest,
    this.maxEligibleAmt,
    this.maxEligibility,
    this.tenure,
    this.notEligibleMessage,
    this.monthlyFixedSalary,
    this.addiMonthlyIncome,
    this.autoFinance,
    this.personalFinance,
    this.homeFinance,
    this.otherInstallments,
    this.creditCardLimit,
    this.isEligible,
  });

  factory EligibilityEntity.fromJson(Map<String, dynamic> json) =>
      EligibilityEntity(
        chMessage:
            json['chMessage'] != null
                ? ChMessage.fromJson(json['chMessage'])
                : null,
        urlDecision: json['urlDecision'],
        value: json['value'],
        message: json['message'],
        eligibility: json['eligibility'],
        emiLoanRequest: json['emiLoanRequest'],
        maxEligibleAmt: json['maxEligibleAmt'],
        maxEligibility: json['maxEligibility'],
        tenure: json['tenure'],
        notEligibleMessage: json['notEligibleMessage'],
        isEligible: json['isEligible'],

        monthlyFixedSalary: (json['monthlyFixedSalary'] as num?)?.toDouble(),
        addiMonthlyIncome: (json['addiMonthlyIncome'] as num?)?.toDouble(),
        autoFinance: (json['autoFinance'] as num?)?.toDouble(),
        personalFinance: (json['personalFinance'] as num?)?.toDouble(),
        homeFinance: (json['homeFinance'] as num?)?.toDouble(),
        otherInstallments: (json['otherInstallments'] as num?)?.toDouble(),
        creditCardLimit: (json['creditCardLimit'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'chMessage': chMessage,
    'urlDecision': urlDecision,
    'value': value,
    'message': message,
    'eligibility': eligibility,
    'emiLoanRequest': emiLoanRequest,
    'maxEligibleAmt': maxEligibleAmt,
    'maxEligibility': maxEligibility,
    'tenure': tenure,
    'notEligibleMessage': notEligibleMessage,
    'monthlyFixedSalary': monthlyFixedSalary,
    'addiMonthlyIncome': addiMonthlyIncome,
    'autoFinance': autoFinance,
    'personalFinance': personalFinance,
    'homeFinance': homeFinance,
    'otherInstallments': otherInstallments,
    'creditCardLimit': creditCardLimit,
    'isEligible': isEligible,
  };
}

class ChMessage {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool? isError;

  ChMessage({this.code, this.message, this.type, this.dispType, this.isError});

  factory ChMessage.fromJson(Map<String, dynamic> json) => ChMessage(
    code: json['code'],
    message: json['message'],
    type: json['type'],
    dispType: json['dispType'],
    isError: json['isError'],
  );
}
