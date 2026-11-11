class PersonalLoanList {
  PersonalLoanList({
    this.bankName,
    this.branchId,
    this.bankLogo,
    this.requestedloanAmount,
    this.status,
    this.statusType,
    this.refNumber,
    this.plEligibilityAmt,
    this.dateTime,
    this.loanType,
    this.loanAmount,
    this.stockName,
    this.chatId,
    this.lastMsgSendBy,
    this.isEditable,
    this.comments,
    this.leadId,
    this.bankId,
    this.sactionDocId,
    this.isStatusUpdated,
    this.ccy,
  });

  PersonalLoanList.fromJson(dynamic json) {
    bankName = json['bankName'];
    bankId = json['bankId'];
    branchId = json['branchId'];
    bankLogo = json['bankLogo'];
    requestedloanAmount = json['requestedloanAmount'];
    status = json['status'];
    statusType = json['statusType'];
    refNumber = json['refNumber'];
    plEligibilityAmt = json['plEligibilityAmt'];
    dateTime = json['dateTime'];
    loanType = json['loanType'];
    loanAmount = json['loanAmount'];
    stockName = json['stockName'];
    leadId = json['leadId'];
    chatId = json['chatId'];
    lastMsgSendBy = json['lastMsgSendBy'];
    isEditable = json['isEditable'];
    comments = json['comments'];
    sactionDocId = json['sactionDocId'];
    isStatusUpdated = json['isStatusUpdated'];
    ccy = json['ccy'];
  }
  String? bankName;
  int? branchId;
  int? bankId;
  String? bankLogo;
  double? requestedloanAmount;
  String? status;
  String? statusType;
  String? refNumber;
  double? plEligibilityAmt;
  String? dateTime;
  String? loanType;
  int? chatId;
  String? lastMsgSendBy;
  String? comments;
  dynamic loanAmount;
  dynamic stockName;
  int? leadId;
  bool? isEditable;
  String? sactionDocId;
  bool? isStatusUpdated;
  String? ccy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bankName'] = bankName;
    map['bankId'] = bankId;
    map['comments'] = comments;
    map['branchId'] = branchId;
    map['bankLogo'] = bankLogo;
    map['requestedloanAmount'] = requestedloanAmount;
    map['status'] = status;
    map['statusType'] = statusType;
    map['refNumber'] = refNumber;
    map['plEligibilityAmt'] = plEligibilityAmt;
    map['dateTime'] = dateTime;
    map['loanType'] = loanType;
    map['loanAmount'] = loanAmount;
    map['stockName'] = stockName;
    map['leadId'] = leadId;
    map['chatId'] = chatId;
    map['lastMsgSendBy'] = lastMsgSendBy;
    map['isEditable'] = isEditable;
    map['sactionDocId'] = sactionDocId;
    map['isStatusUpdated'] = isStatusUpdated;
    map['ccy'] = ccy;
    return map;
  }
}
