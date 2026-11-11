import 'GdbCustAddressForm.dart';
import 'GdbLookupForm.dart';

class GdbCustRtlEmpDetForm {
  GdbLookupForm? empStatus;
  GdbLookupForm? employerName;
  GdbLookupForm? industry;
  String? hiringDate;
  String? jobTitle;
  double? netMonthlyIncome;
  double? netMonthlyExpense;
  GdbCustAddressForm? workingAddress;
  String? currEmpBuildNo;
  String? currEmpStrNo;
  String? currEmpDistName;
  String? currEmpGover;

  GdbCustRtlEmpDetForm({
    this.empStatus,
    this.employerName,
    this.industry,
    this.hiringDate,
    this.jobTitle,
    this.netMonthlyIncome,
    this.netMonthlyExpense,
    this.workingAddress,
    this.currEmpBuildNo,
    this.currEmpStrNo,
    this.currEmpDistName,
    this.currEmpGover,
  });

  factory GdbCustRtlEmpDetForm.fromJson(Map<String, dynamic> json) {
    return GdbCustRtlEmpDetForm(
      empStatus: json['empStatus'] != null
          ? GdbLookupForm.fromJson(json['empStatus'])
          : null,
      employerName: json['employerName'] != null
          ? GdbLookupForm.fromJson(json['employerName'])
          : null,
      industry: json['industry'] != null
          ? GdbLookupForm.fromJson(json['industry'])
          : null,
      hiringDate: json['hiringDate'],
      jobTitle: json['jobTitle'],
      netMonthlyIncome: (json['netMonthlyIncome'] as num?)?.toDouble(),
      netMonthlyExpense: (json['netMonthlyExpense'] as num?)?.toDouble(),
      workingAddress: json['workingAddress'] != null
          ? GdbCustAddressForm.fromJson(json['workingAddress'])
          : null,
      currEmpBuildNo: json['currEmpBuildNo'],
      currEmpStrNo: json['currEmpStrNo'],
      currEmpDistName: json['currEmpDistName'],
      currEmpGover: json['currEmpGover'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empStatus': empStatus?.toJson(),
      'employerName': employerName?.toJson(),
      'industry': industry?.toJson(),
      'hiringDate': hiringDate,
      'jobTitle': jobTitle,
      'netMonthlyIncome': netMonthlyIncome,
      'netMonthlyExpense': netMonthlyExpense,
      'workingAddress': workingAddress?.toJson(),
      'currEmpBuildNo': currEmpBuildNo,
      'currEmpStrNo': currEmpStrNo,
      'currEmpDistName': currEmpDistName,
      'currEmpGover': currEmpGover,
    };
  }
}
