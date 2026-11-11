import 'common/ch_message.dart';

class CropInsuranceResponse {
  ChMessage? chMessage;
  String? farmingPlanId;
  String? screenId;
  String? status;
  String? sumInsured;
  String? groupShare;
  String? groupPremiumAmt;
  String? governmentShare;
  String? governmentPrmAmt;
  String? activateFromDate;
  String? activateToDate;

  CropInsuranceResponse.fromJson(Map<String, dynamic> json) {
    chMessage =
        json["chMessage"] != null
            ? ChMessage.fromJson(json["chMessage"])
            : null;
    farmingPlanId = json["farmingPlanId"];
    screenId = json["screenId"];
    status = json["status"];
    sumInsured = json["sumInsured"];
    groupShare = json["groupShare"];
    groupPremiumAmt = json["groupPremiumAmt"];
    governmentShare = json["governmentShare"];
    governmentPrmAmt = json["governmentPrmAmt"];
    activateFromDate = json["activateFromDate"];
    activateToDate = json["activateToDate"];
  }
}
