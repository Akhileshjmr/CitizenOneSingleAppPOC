import 'package:citizenone_app/modules/agrinet/app/data/model/common/ch_message.dart';

import '../common/docs.dart';

class FileUploadResponse {
  List<dynamic>? boothList;
  List<dynamic>? selectOptionList;
  dynamic checkEligibForm;
  String? tempStr;
  dynamic securityQues;
  List<dynamic>? vendors;
  List<dynamic>? promotions;
  Docs? docs;
  dynamic advertiseDocs;
  dynamic cmOtherDocs;
  ChMessage? message;
  dynamic formerList;
  dynamic agriFormerList;
  dynamic cropPrdList;
  dynamic vendor;
  String? status;
  dynamic mobileScreen;

  FileUploadResponse({
    this.boothList,
    this.selectOptionList,
    this.checkEligibForm,
    this.tempStr,
    this.securityQues,
    this.vendors,
    this.promotions,
    this.docs,
    this.advertiseDocs,
    this.cmOtherDocs,
    this.message,
    this.formerList,
    this.agriFormerList,
    this.cropPrdList,
    this.vendor,
    this.status,
    this.mobileScreen,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      boothList: json["boothList"],
      selectOptionList: json["selectOptionList"],
      checkEligibForm: json["checkEligibForm"],
      tempStr: json["tempStr"],
      securityQues: json["securityQues"],
      vendors: json["vendors"],
      promotions: json["promotions"],
      docs: json["docs"] != null ? Docs.fromJson(json["docs"]) : null,
      advertiseDocs: json["advertiseDocs"],
      cmOtherDocs: json["cmOtherDocs"],
      message:
          json["message"] != null ? ChMessage.fromJson(json["message"]) : null,
      formerList: json["formerList"],
      agriFormerList: json["agriFormerList"],
      cropPrdList: json["cropPrdList"],
      vendor: json["vendor"],
      status: json["status"],
      mobileScreen: json["mobileScreen"],
    );
  }

  Map<String, dynamic> toJson() => {
    "boothList": boothList,
    "selectOptionList": selectOptionList,
    "checkEligibForm": checkEligibForm,
    "tempStr": tempStr,
    "securityQues": securityQues,
    "vendors": vendors,
    "promotions": promotions,
    "docs": docs?.toJson(),
    "advertiseDocs": advertiseDocs,
    "cmOtherDocs": cmOtherDocs,
    "message": message?.toJson(),
    "formerList": formerList,
    "agriFormerList": agriFormerList,
    "cropPrdList": cropPrdList,
    "vendor": vendor,
    "status": status,
    "mobileScreen": mobileScreen,
  };
}
