import 'GdbChMediaAction.dart';
import 'Status.dart';

class LoanList {
  LoanList({
    this.custId,
    this.custCode,
    this.firstName,
    this.eligibleLimit,
    this.status,
    this.activateDate,
    this.expiryDate,
    this.suggestedLimit,
    this.utilisedLimit,
    this.blockDate,
    this.comments,
    this.bankName,
    this.availableLimit,
    this.submissionDate,
    this.bankProductId,
    this.limitKey,
    this.reason,
    this.loanType,
    this.remarks,
    this.gdbChMediaAction,
    this.applicationNumber,
    this.sanctionedLetter,
    this.tenure,
    this.emi,
    this.loanAmount,
    this.category,
    this.loanAppNum,
    this.id,
    this.refNum,
  });

  LoanList.fromJson(dynamic json) {
    custId = json['custId'];
    custCode = json['custCode'];
    firstName = json['firstName'];
    eligibleLimit = json['eligibleLimit'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    activateDate = json['activateDate'];
    expiryDate = json['expiryDate'];
    suggestedLimit = json['suggestedLimit'];
    utilisedLimit = json['utilisedLimit'];
    blockDate = json['blockDate'];
    comments = json['comments'];
    bankName = json['bankName'];
    availableLimit = json['availableLimit'];
    submissionDate = json['submissionDate'];
    bankProductId = json['bankProductId'];
    limitKey = json['limitKey'];
    reason = json['reason'];
    loanType = json['loanType'];
    remarks = json['remarks'];
    gdbChMediaAction =
        json['gdbChMediaAction'] != null
            ? GdbChMediaAction.fromJson(json['gdbChMediaAction'])
            : null;
    applicationNumber = json['applicationNumber'];
    sanctionedLetter = json['sanctionedLetter'];
    tenure = json['tenure'];
    emi = json['emi'];
    loanAmount = json['loanAmount'];
    category = json['category'];
    loanAppNum = json['loanAppNum'];
    id = json['id'];
    refNum = json['refNum'];
  }
  String? custId;
  String? custCode;
  String? firstName;
  String? eligibleLimit;
  Status? status;
  String? activateDate;
  String? expiryDate;
  String? suggestedLimit;
  String? utilisedLimit;
  dynamic blockDate;
  dynamic comments;
  String? bankName;
  String? availableLimit;
  String? submissionDate;
  String? bankProductId;
  String? limitKey;
  dynamic reason;
  String? loanType;
  dynamic remarks;
  GdbChMediaAction? gdbChMediaAction;
  dynamic applicationNumber;
  dynamic sanctionedLetter;
  String? tenure;
  String? emi;
  dynamic loanAmount;
  dynamic category;
  dynamic loanAppNum;
  dynamic id;
  String? refNum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['custId'] = custId;
    map['custCode'] = custCode;
    map['firstName'] = firstName;
    map['eligibleLimit'] = eligibleLimit;
    if (status != null) {
      map['status'] = status?.toJson();
    }
    map['activateDate'] = activateDate;
    map['expiryDate'] = expiryDate;
    map['suggestedLimit'] = suggestedLimit;
    map['utilisedLimit'] = utilisedLimit;
    map['blockDate'] = blockDate;
    map['comments'] = comments;
    map['bankName'] = bankName;
    map['availableLimit'] = availableLimit;
    map['submissionDate'] = submissionDate;
    map['bankProductId'] = bankProductId;
    map['limitKey'] = limitKey;
    map['reason'] = reason;
    map['loanType'] = loanType;
    map['remarks'] = remarks;
    if (gdbChMediaAction != null) {
      map['gdbChMediaAction'] = gdbChMediaAction?.toJson();
    }
    map['applicationNumber'] = applicationNumber;
    map['sanctionedLetter'] = sanctionedLetter;
    map['tenure'] = tenure;
    map['emi'] = emi;
    map['loanAmount'] = loanAmount;
    map['category'] = category;
    map['loanAppNum'] = loanAppNum;
    map['id'] = id;
    map['refNum'] = refNum;
    return map;
  }
}
