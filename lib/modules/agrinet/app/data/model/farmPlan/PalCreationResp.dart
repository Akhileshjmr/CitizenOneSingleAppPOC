import '../shgDetails/shgDetailsResp.dart';

class PalcreationResp {
  PalcreationResp({
    this.boothList,
    this.selectOptionList,
    this.checkEligibForm,
    this.tempStr,
    this.securityQues,
    this.vendors,
    this.promotions,
    this.message,
  });

  dynamic boothList;
  List<SelectOptionList>? selectOptionList;
  dynamic checkEligibForm;
  dynamic tempStr;
  dynamic securityQues;
  dynamic vendors;
  dynamic promotions;
  Message? message;

  factory PalcreationResp.fromJson(Map<String, dynamic> json) =>
      PalcreationResp(
        boothList: json["boothList"],
        selectOptionList:
            json["selectOptionList"] == null
                ? []
                : List<SelectOptionList>.from(
                  json["selectOptionList"]!.map(
                    (x) => SelectOptionList.fromJson(x),
                  ),
                ),
        checkEligibForm: json["checkEligibForm"],
        tempStr: json["tempStr"],
        securityQues: json["securityQues"],
        vendors: json["vendors"],
        promotions: json["promotions"],
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
    "boothList": boothList,
    "selectOptionList":
        selectOptionList == null
            ? []
            : List<dynamic>.from(selectOptionList!.map((x) => x.toJson())),
    "checkEligibForm": checkEligibForm,
    "tempStr": tempStr,
    "securityQues": securityQues,
    "vendors": vendors,
    "promotions": promotions,
    "message": message?.toJson(),
  };
}

class Message {
  Message({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
    this.dataArr,
  });

  String? code;
  String? message;
  String? type;
  String? dispType;
  bool? isError;
  String? subject;
  dynamic dataArr;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    code: json["code"],
    message: json["message"],
    type: json["type"],
    dispType: json["dispType"],
    isError: json["isError"],
    subject: json["subject"],
    dataArr: json["dataArr"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "type": type,
    "dispType": dispType,
    "isError": isError,
    "subject": subject,
    "dataArr": dataArr,
  };
}
