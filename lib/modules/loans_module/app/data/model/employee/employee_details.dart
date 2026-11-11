import 'Industry.dart';
import 'employee_status.dart';
import 'employer_name.dart';

class EmployeeDetails {
  EmployeeDetails({
    this.empStatus,
    this.employerName,
    this.industry,
    this.dateOfJoining,
    this.designation,
    this.netMonthlyIncome,
    this.lenthOfService,
    this.country,
    this.annualIncome,
    this.yearsInBusiness,
    // this.lastUpdatedDate,
    this.othrIncome,
    this.houseAllowance,
    this.spouseIncome,
    this.monthlyCommitments,
    this.empNum,
    this.officeTelNum,
    this.officeMailId,
    this.extension,
  });

  EmployeeDetails.fromJson(dynamic json) {
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
    dateOfJoining = json['dateOfJoining'];
    designation = json['designation'];
    netMonthlyIncome = json['netMonthlyIncome'];
    lenthOfService = json['lenthOfService'];
    country = json['country'];
    annualIncome = json['annualIncome'];
    yearsInBusiness = json['yearsInBusiness'];
    // lastUpdatedDate = json['lastUpdatedDate'];
    othrIncome = json['othrIncome'];
    houseAllowance = json['houseAllowance'];
    spouseIncome = json['spouseIncome'];
    monthlyCommitments = json['monthlyCommitments'];
    empNum = json['empNum'];
    officeTelNum = json['officeTelNum'];
    officeMailId = json['officeMailId'];
    extension = json['extension'];
  }
  EmpStatus? empStatus;
  EmployerName? employerName;
  Industry? industry;
  String? dateOfJoining;
  String? designation;
  double? netMonthlyIncome;
  int? lenthOfService;
  dynamic country;
  double? annualIncome;
  String? yearsInBusiness;
  // String? lastUpdatedDate;
  String? othrIncome;
  String? houseAllowance;
  String? spouseIncome;
  String? monthlyCommitments;
  String? empNum;
  String? officeTelNum;
  String? officeMailId;
  String? extension;

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
    map['dateOfJoining'] = dateOfJoining;
    map['designation'] = designation;
    map['netMonthlyIncome'] = netMonthlyIncome;
    map['lenthOfService'] = lenthOfService;
    map['country'] = country;
    map['annualIncome'] = annualIncome;
    map['yearsInBusiness'] = yearsInBusiness;
    // map['lastUpdatedDate'] = lastUpdatedDate;
    map['othrIncome'] = othrIncome;
    map['houseAllowance'] = houseAllowance;
    map['spouseIncome'] = spouseIncome;
    map['monthlyCommitments'] = monthlyCommitments;
    map['empNum'] = empNum;
    map['officeTelNum'] = officeTelNum;
    map['officeMailId'] = officeMailId;
    map['extension'] = extension;
    return map;
  }
}
