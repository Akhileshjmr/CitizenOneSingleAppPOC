import 'package:citizenone_app/modules/agrinet/app/data/model/user/expense_details.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/user/yeild_details.dart';

import '../onboarding/onboarding_farmer_list.dart';
import '../service_request/upload_doc.dart';
import '../user/commun_details.dart';
import '../user/income_details.dart';
import '../user/land_holding.dart';
import '../user/member_details.dart';

class Docs {
  String? reqSecureKey;
  String? filterVal;
  String? addiParams;
  int? id;
  GeneralDetails? generalDetails;
  dynamic bankDetails;
  dynamic uniqIdDetail;
  CommunDetails? communDetails;
  dynamic incomeDet;
  List<IncomeDetails>? incDetails;
  List<ExpenseDetails>? expDetails;
  dynamic assetDetails;
  dynamic liabDetails;
  List<LandHolding>? landHolding;
  List<YieldDetails>? yieldDetails;
  List<MemberDetails>? memberDetails;
  List<DocDet>? docDet;
  dynamic mobileScreen;
  dynamic farmId;
  dynamic status;

  Docs({
    this.reqSecureKey,
    this.filterVal,
    this.addiParams,
    this.id,
    this.generalDetails,
    this.bankDetails,
    this.uniqIdDetail,
    this.communDetails,
    this.incomeDet,
    this.incDetails,
    this.expDetails,
    this.assetDetails,
    this.liabDetails,
    this.landHolding,
    this.yieldDetails,
    this.memberDetails,
    this.docDet,
    this.mobileScreen,
    this.farmId,
    this.status,
  });

  factory Docs.fromJson(Map<String, dynamic> json) {
    return Docs(
      reqSecureKey: json["reqSecureKey"],
      filterVal: json["filterVal"],
      addiParams: json["addiParams"],
      id: json["id"],
      generalDetails:
          json["generalDetails"] != null
              ? GeneralDetails.fromJson(json["generalDetails"])
              : null,
      bankDetails: json["bankDetails"],
      uniqIdDetail: json["uniqIdDetail"],
      communDetails:
          json['communDetails'] != null
              ? CommunDetails.fromJson(json['communDetails'])
              : null,
      incomeDet: json["incomeDet"],
      incDetails:
          json['incDetails'] != null
              ? List<IncomeDetails>.from(
                json['incDetails'].map((x) => IncomeDetails.fromJson(x)),
              )
              : null,
      expDetails:
          json['expDetails'] != null
              ? List<ExpenseDetails>.from(
                json['expDetails'].map((x) => ExpenseDetails.fromJson(x)),
              )
              : null,
      assetDetails: json["assetDetails"],
      liabDetails: json["liabDetails"],
      landHolding:
          json['landHolding'] != null
              ? List<LandHolding>.from(
                json['landHolding'].map((x) => LandHolding.fromJson(x)),
              )
              : null,
      yieldDetails:
          json['yieldDetails'] != null
              ? List<YieldDetails>.from(
                json['yieldDetails'].map((x) => YieldDetails.fromJson(x)),
              )
              : null,
      memberDetails:
          json["memberDetails"] != null
              ? List<MemberDetails>.from(
                json["memberDetails"].map((x) => MemberDetails.fromJson(x)),
              )
              : null,
      docDet:
          json["docDet"] != null
              ? List<DocDet>.from(json["docDet"].map((x) => DocDet.fromJson(x)))
              : null,
      mobileScreen: json["mobileScreen"],
      farmId: json["farmId"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "reqSecureKey": reqSecureKey,
    "filterVal": filterVal,
    "addiParams": addiParams,
    "id": id,
    "generalDetails": generalDetails?.toJson(),
    "bankDetails": bankDetails,
    "uniqIdDetail": uniqIdDetail,
    "communDetails": communDetails,
    "incomeDet": incomeDet,
    "incDetails": incDetails,
    "expDetails": expDetails,
    "assetDetails": assetDetails,
    "liabDetails": liabDetails,
    "landHolding": landHolding,
    "yieldDetails": yieldDetails,
    "memberDetails": memberDetails,
    "mobileScreen": mobileScreen,
    "farmId": farmId,
    "status": status,
  };
}
