import '../common/ch_message.dart';
import '../common/select_option_item.dart';
import 'group_member.dart';

class GroupFarmerList {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic id;
  dynamic farmingPlanId;
  dynamic latitude;
  dynamic longitude;
  String? name;
  String? desc;
  String? screenId;
  dynamic groupId;
  String? soilType;
  String? status;
  dynamic createdDate;
  dynamic docs;
  List<GroupMember>? groupDetails;
  dynamic soilAssessment;
  dynamic recommendedCrop;
  dynamic mappingDetails;
  dynamic farmingGrowthFactorsRisks;
  dynamic yieldDet;
  dynamic financeRequest;

  List<SelectOptionItem>? selectOptionList;

  GroupFarmerList({
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
    this.groupDetails,
    this.soilAssessment,
    this.recommendedCrop,
    this.mappingDetails,
    this.farmingGrowthFactorsRisks,
    this.yieldDet,
    this.financeRequest,
    this.selectOptionList,
  });

  factory GroupFarmerList.fromJson(Map<String, dynamic> json) {
    return GroupFarmerList(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      id: json['id'],
      farmingPlanId: json['farmingPlanId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      name: json['name'],
      desc: json['desc'],
      screenId: json['screenId'],
      groupId: json['groupId'],
      soilType: json['soilType'],
      status: json['status'],
      createdDate: json['createdDate'],
      docs: json['docs'],
      groupDetails:
          json["groupDetails"] != null
              ? (json["groupDetails"] as List)
                  .map((e) => GroupMember.fromJson(e))
                  .toList()
              : null,

      soilAssessment: json['soilAssessment'],
      recommendedCrop: json['recommendedCrop'],
      mappingDetails: json['mappingDetails'],
      farmingGrowthFactorsRisks: json['farmingGrowthFactorsRisks'],
      yieldDet: json['yieldDet'],
      financeRequest: json['financeRequest'],
      selectOptionList:
          json['selectOptionList'] != null
              ? (json['selectOptionList'] as List)
                  .map((e) => SelectOptionItem.fromJson(e))
                  .toList()
              : null,
    );
  }
}
