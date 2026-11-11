import '../../../common/ch_message.dart';
import '../../bank_list/paging.dart';
import 'LoanList.dart';

class PrLoanHistoryResp {
  PrLoanHistoryResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.paging,
    this.limitList,
    this.currLimit,
    this.loanList,
    this.questions,
    this.questionsAnswers,
  });

  PrLoanHistoryResp.fromJson(dynamic json) {
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
    paging = json['paging'] != null ? Paging.fromJson(json['paging']) : null;
    limitList = json['limitList'];
    currLimit = json['currLimit'];
    if (json['loanList'] != null) {
      loanList = [];
      json['loanList'].forEach((v) {
        loanList?.add(LoanList.fromJson(v));
      });
    }
    questions = json['questions'];
    questionsAnswers = json['questionsAnswers'];
  }
  dynamic reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  Paging? paging;
  dynamic limitList;
  dynamic currLimit;
  List<LoanList>? loanList;
  dynamic questions;
  dynamic questionsAnswers;

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
    if (paging != null) {
      map['paging'] = paging?.toJson();
    }
    map['limitList'] = limitList;
    map['currLimit'] = currLimit;
    if (loanList != null) {
      map['loanList'] = loanList?.map((v) => v.toJson()).toList();
    }
    map['questions'] = questions;
    map['questionsAnswers'] = questionsAnswers;
    return map;
  }
}
