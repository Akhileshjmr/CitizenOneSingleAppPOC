import '../common/ch_message.dart';
import 'PreApprove/preApproveBankList/BankListForLoanList.dart';

class PreBankListResp {
  PreBankListResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.paging,
    this.bankListForLoanList,
  });

  PreBankListResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    paging = json['paging'];
    if (json['bankListForLoanList'] != null) {
      bankListForLoanList = [];
      json['bankListForLoanList'].forEach((v) {
        bankListForLoanList?.add(BankListForLoanList.fromJson(v));
      });
    }
  }
  dynamic reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  dynamic paging;
  List<BankListForLoanList>? bankListForLoanList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    map['otp'] = otp;
    map['paging'] = paging;
    if (bankListForLoanList != null) {
      map['bankListForLoanList'] =
          bankListForLoanList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
