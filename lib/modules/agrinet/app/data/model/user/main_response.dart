import 'package:citizenone_app/modules/agrinet/app/data/model/user/select_option.dart';

import '../common/ch_message.dart';
import '../common/docs.dart';
import '../common/option.dart';
import 'cm_other_doc.dart';

class MainResponse {
  List<dynamic>? boothList;
  List<SelectOption>? selectOptionList;
  dynamic checkEligibForm;
  String? tempStr;
  dynamic securityQues;
  dynamic vendors;
  dynamic promotions;
  Docs? docs;
  dynamic advertiseDocs;
  List<CmOtherDoc>? cmOtherDocs;
  ChMessage? message;
  dynamic formerList;
  dynamic agriFormerList;
  dynamic cropPrdList;
  dynamic vendor;
  String? status;
  String? mobileScreen;

  MainResponse({
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

  factory MainResponse.fromJson(Map<String, dynamic> json) => MainResponse(
    boothList: json["boothList"],
    selectOptionList:
        json["selectOptionList"] == null
            ? []
            : List<SelectOption>.from(
              json["selectOptionList"].map((x) => SelectOption.fromJson(x)),
            ),
    checkEligibForm: json["checkEligibForm"],
    tempStr: json["tempStr"],
    securityQues: json["securityQues"],
    vendors: json["vendors"],
    promotions: json["promotions"],
    docs: json["docs"] != null ? Docs.fromJson(json["docs"]) : null,
    advertiseDocs: json["advertiseDocs"],
    cmOtherDocs:
        json["cmOtherDocs"] != null
            ? (json['cmOtherDocs'] as List)
                .map((e) => CmOtherDoc.fromJson(e))
                .toList()
            : null,

    message:
        json["chMessage"] != null
            ? ChMessage.fromJson(json["chMessage"])
            : json["message"] != null
            ? ChMessage.fromJson(json["message"])
            : null,
    formerList: json["formerList"],
    agriFormerList: json["agriFormerList"],
    cropPrdList: json["cropPrdList"],
    vendor: json["vendor"],
    status: json["status"],
    mobileScreen: json["mobileScreen"],
  );

  Map<String, dynamic> toJson() => {
    "boothList": boothList,
    "selectOptionList": selectOptionList?.map((x) => x.toJson()).toList(),
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

extension MainResponseExtension on MainResponse {
  List<Option>? getOptionsByKey(String key) {
    if (selectOptionList == null) return null;

    for (var item in selectOptionList!) {
      if (item.key == key) {
        return item.options;
      }
    }
    return null;
  }
}
