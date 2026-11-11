import '../../../employee/Industry.dart';
import 'EmpStatus.dart';
import 'EmployerName.dart';
import 'WorkingAddress.dart';

class EmpDetails {
  EmpDetails({
    this.empStatus,
    this.employerName,
    this.industry,
    this.hiringDate,
    this.jobTitle,
    this.netMonthlyIncome,
    this.netMonthlyExpense,
    this.loanAmountNeed,
    this.annualTurnover,
    this.monthlyRent,
    this.salariedOrSelfemployed,
    this.salariWithBank,
    this.yearOfExp,
    this.yearOfTaxReturn,
    this.employeName,
    this.lenthOfService,
    this.monthlyIncomeEnc,
    this.monthlyExpenseInc,
    this.previousEmployer,
    this.previousEmployerDesgnatn,
    this.previousEmployerLenthOfService,
    this.previousEmployerAddress,
    this.previousEmployerPhoneNum,
    this.officeTelNumber,
    this.emirate,
    this.postBoxNum,
    this.country,
    this.workingAddress,
  });

  EmpDetails.fromJson(dynamic json) {
    empStatus =
        json['empStatus'] != null
            ? EmpStatus.fromJson(json['empStatus'])
            : null;
    employerName =
        json['employerName'] != null
            ? EmployerName.fromJson(json['employerName'])
            : null;
    industry =
        json['industry'] != null ? Industry.fromJson(json['industry']) : null;
    hiringDate = json['hiringDate'];
    jobTitle = json['jobTitle'];
    netMonthlyIncome = json['netMonthlyIncome'];
    netMonthlyExpense = json['netMonthlyExpense'];
    loanAmountNeed = json['loanAmountNeed'];
    annualTurnover = json['annualTurnover'];
    monthlyRent = json['monthlyRent'];
    salariedOrSelfemployed = json['salariedOrSelfemployed'];
    salariWithBank = json['salariWithBank'];
    yearOfExp = json['yearOfExp'];
    yearOfTaxReturn = json['yearOfTaxReturn'];
    employeName = json['employeName'];
    lenthOfService = json['lenthOfService'];
    monthlyIncomeEnc = json['monthlyIncomeEnc'];
    monthlyExpenseInc = json['monthlyExpenseInc'];
    previousEmployer = json['previousEmployer'];
    previousEmployerDesgnatn = json['previousEmployerDesgnatn'];
    previousEmployerLenthOfService = json['previousEmployerLenthOfService'];
    previousEmployerAddress = json['previousEmployerAddress'];
    previousEmployerPhoneNum = json['previousEmployerPhoneNum'];
    officeTelNumber = json['officeTelNumber'];
    emirate = json['emirate'];
    postBoxNum = json['postBoxNum'];
    country = json['country'];
    workingAddress =
        json['workingAddress'] != null
            ? WorkingAddress.fromJson(json['workingAddress'])
            : null;
  }
  EmpStatus? empStatus;
  EmployerName? employerName;
  Industry? industry;
  String? hiringDate;
  String? jobTitle;
  double? netMonthlyIncome;
  int? netMonthlyExpense;
  dynamic loanAmountNeed;
  dynamic annualTurnover;
  dynamic monthlyRent;
  dynamic salariedOrSelfemployed;
  dynamic salariWithBank;
  dynamic yearOfExp;
  dynamic yearOfTaxReturn;
  dynamic employeName;
  int? lenthOfService;
  String? monthlyIncomeEnc;
  String? monthlyExpenseInc;
  dynamic previousEmployer;
  dynamic previousEmployerDesgnatn;
  dynamic previousEmployerLenthOfService;
  dynamic previousEmployerAddress;
  dynamic previousEmployerPhoneNum;
  dynamic officeTelNumber;
  dynamic emirate;
  dynamic postBoxNum;
  dynamic country;
  WorkingAddress? workingAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (empStatus != null) {
      map['empStatus'] = empStatus?.toJson();
    }
    if (employerName != null) {
      map['employerName'] = employerName?.toJson();
    }
    if (industry != null) {
      map['industry'] = industry?.toJson();
    }

    map['hiringDate'] = hiringDate;
    map['jobTitle'] = jobTitle;
    map['netMonthlyIncome'] = netMonthlyIncome;
    map['netMonthlyExpense'] = netMonthlyExpense;
    map['loanAmountNeed'] = loanAmountNeed;
    map['annualTurnover'] = annualTurnover;
    map['monthlyRent'] = monthlyRent;
    map['salariedOrSelfemployed'] = salariedOrSelfemployed;
    map['salariWithBank'] = salariWithBank;
    map['yearOfExp'] = yearOfExp;
    map['yearOfTaxReturn'] = yearOfTaxReturn;
    map['employeName'] = employeName;
    map['lenthOfService'] = lenthOfService;
    map['monthlyIncomeEnc'] = monthlyIncomeEnc;
    map['monthlyExpenseInc'] = monthlyExpenseInc;
    map['previousEmployer'] = previousEmployer;
    map['previousEmployerDesgnatn'] = previousEmployerDesgnatn;
    map['previousEmployerLenthOfService'] = previousEmployerLenthOfService;
    map['previousEmployerAddress'] = previousEmployerAddress;
    map['previousEmployerPhoneNum'] = previousEmployerPhoneNum;
    map['officeTelNumber'] = officeTelNumber;
    map['emirate'] = emirate;
    map['postBoxNum'] = postBoxNum;
    map['country'] = country;
    if (workingAddress != null) {
      map['workingAddress'] = workingAddress?.toJson();
    }
    return map;
  }
}
