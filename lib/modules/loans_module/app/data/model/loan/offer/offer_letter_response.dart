import '../../../../modules/profile/ProfileStatusResp.dart';

class OfferLetterResponse {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  dynamic loanAmount;
  dynamic interestRate;
  dynamic tenure;
  dynamic emi;
  dynamic downPayment;
  dynamic charges;
  dynamic orderNumber;
  dynamic bankName;
  dynamic gdbChMediaAction;
  OfferLetter? offerLetter;
  dynamic actualDownpayment;

  OfferLetterResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.loanAmount,
    this.interestRate,
    this.tenure,
    this.emi,
    this.downPayment,
    this.charges,
    this.orderNumber,
    this.bankName,
    this.gdbChMediaAction,
    this.offerLetter,
    this.actualDownpayment,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['reqSecureKey'] = reqSecureKey;
    data['addiParams'] = addiParams;
    if (chMessage != null) {
      data['chMessage'] = chMessage!.toJson();
    }
    data['urlDecision'] = urlDecision;
    data['value'] = value;
    data['otp'] = otp;
    data['loanAmount'] = loanAmount;
    data['interestRate'] = interestRate;
    data['tenure'] = tenure;
    data['emi'] = emi;
    data['downPayment'] = downPayment;
    data['charges'] = charges;
    data['orderNumber'] = orderNumber;
    data['bankName'] = bankName;
    data['gdbChMediaAction'] = gdbChMediaAction;

    if (offerLetter != null) {
      data['offerLetter'] = offerLetter!.toJson();
    }

    data['actualDownpayment'] = actualDownpayment;
    return data;
  }

  factory OfferLetterResponse.fromJson(Map<String, dynamic> json) =>
      OfferLetterResponse(
        reqSecureKey: json['reqSecureKey'],
        addiParams: json['addiParams'],
        chMessage:
            json['chMessage'] != null
                ? ChMessage.fromJson(json['chMessage'])
                : null,
        urlDecision: json['urlDecision'],
        value: json['value'],
        otp: json['otp'],
        loanAmount: json['loanAmount'],
        interestRate: json['interestRate'],
        tenure: json['tenure'],
        emi: json['emi'],
        downPayment: json['downPayment'],
        charges: json['charges'],
        orderNumber: json['orderNumber'],
        bankName: json['bankName'],
        gdbChMediaAction: json['gdbChMediaAction'],
        offerLetter:
            json['offerLetter'] != null
                ? OfferLetter.fromJson(json['offerLetter'])
                : null,
        actualDownpayment: json['actualDownpayment'],
      );
}

/*class ChMessage {
  dynamic code;
  dynamic message;
  dynamic type;
  String? dispType;
  bool? isError;
  String? subject;
  dynamic dataArr;

  ChMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
    this.dataArr,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) => ChMessage(
      code: json['code'],
      message: json['message'],
      type: json['type'],
      dispType: json['dispType'],
      isError: json['isError'],
      subject: json['subject'],
      dataArr: json['dataArr'],
    );
}*/

class OfferLetter {
  String? type;
  UrlAction? urlAction;

  OfferLetter({this.type, this.urlAction});

  factory OfferLetter.fromJson(Map<String, dynamic> json) => OfferLetter(
    type: json['type'],
    urlAction:
        json['urlAction'] != null
            ? UrlAction.fromJson(json['urlAction'])
            : null,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (urlAction != null) {
      data['urlAction'] = urlAction!.toJson();
    }
    return data;
  }
}

class UrlAction {
  String? actionType;
  String? url;
  dynamic id;

  UrlAction({this.actionType, this.url, this.id});

  factory UrlAction.fromJson(Map<String, dynamic> json) => UrlAction(
    actionType: json['actionType'],
    url: json['url'],
    id: json['id'],
  );
  Map<String, dynamic> toJson() => {
    'actionType': actionType,
    'url': url,
    'id': id,
  };
}
