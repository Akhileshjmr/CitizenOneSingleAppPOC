import '../common/ch_message.dart';
import '../common/option.dart';

class SavePlanResponse {
  final String? reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final dynamic id;
  final String? farmingPlanId;
  final dynamic latitude;
  final dynamic longitude;
  final String? name;
  final String? desc;
  final String? screenId;
  final Option? groupId;
  final String? soilType;
  final String? status;
  final dynamic createdDate;
  final dynamic docs;

  SavePlanResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.id,
    this.farmingPlanId,
    this.latitude,
    this.longitude,
    this.name,
    this.desc,
    this.screenId,
    this.groupId,
    this.soilType,
    this.status,
    this.createdDate,
    this.docs,
  });

  factory SavePlanResponse.fromJson(Map<String, dynamic> json) {
    return SavePlanResponse(
      reqSecureKey: json["reqSecureKey"],
      addiParams: json["addiParams"],
      chMessage:
          json["chMessage"] != null
              ? ChMessage.fromJson(json["chMessage"])
              : null,
      urlDecision: json["urlDecision"],
      id: json["id"],
      farmingPlanId: json["farmingPlanId"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      name: json["name"],
      desc: json["desc"],
      screenId: json["screenId"],
      groupId:
          json["groupId"] != null ? Option.fromJson(json["groupId"]) : null,
      soilType: json["soilType"],
      status: json["status"],
      createdDate: json["createdDate"],
      docs: json["docs"],
    );
  }
}
