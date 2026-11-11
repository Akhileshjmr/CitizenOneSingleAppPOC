import '../common/ch_message.dart';

class SubmitResponse {
  final dynamic reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final dynamic serviceReq;
  final String? tempStr;
  final dynamic docs;
  final dynamic cmOtherDocs;

  SubmitResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.serviceReq,
    this.tempStr,
    this.docs,
    this.cmOtherDocs,
  });

  factory SubmitResponse.fromJson(Map<String, dynamic> json) {
    return SubmitResponse(
      reqSecureKey: json["reqSecureKey"],
      addiParams: json["addiParams"],
      chMessage:
          json["chMessage"] != null
              ? ChMessage.fromJson(json["chMessage"])
              : null,
      urlDecision: json["urlDecision"],
      serviceReq: json["serviceReq"],
      tempStr: json["tempStr"],
      docs: json["docs"],
      cmOtherDocs: json["cmOtherDocs"],
    );
  }
}
