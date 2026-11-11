import '../common/ch_message.dart';

class soilAssessmentResp {
  Null? reqSecureKey;
  Null? addiParams;
  ChMessage? chMessage;
  Null? urlDecision;
  Null? id;
  String? farmingPlanId;
  Null? latitude;
  Null? longitude;
  Null? name;
  Null? desc;
  String? screenId;
  GroupId? groupId;
  SoilType? soilType;
  String? status;
  Null? createdDate;
  Null? docs;
  Null? groupDetails;
  List<SoilAssessment>? soilAssessment;
  Null? recommendedCrop;
  Null? mappingDetails;
  Null? farmingGrowthFactorsRisks;
  Null? yieldDet;
  Null? financeRequest;
  Null? selectOptionList;
  Null? calenderEvents;
  Null? agriInputEst;
  Null? selectAppStatus;
  Null? sumInsured;
  Null? groupShare;
  Null? groupPremiumAmt;
  Null? governmentShare;
  Null? governmentPrmAmt;
  Null? activateFromDate;
  Null? activateToDate;
  Null? score;
  Null? cmOtherDocs;

  soilAssessmentResp(
      {this.reqSecureKey,
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
        this.calenderEvents,
        this.agriInputEst,
        this.selectAppStatus,
        this.sumInsured,
        this.groupShare,
        this.groupPremiumAmt,
        this.governmentShare,
        this.governmentPrmAmt,
        this.activateFromDate,
        this.activateToDate,
        this.score,
        this.cmOtherDocs});

  soilAssessmentResp.fromJson(Map<String, dynamic> json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage = json['chMessage'] != null
        ? new ChMessage.fromJson(json['chMessage'])
        : null;
    urlDecision = json['urlDecision'];
    id = json['id'];
    farmingPlanId = json['farmingPlanId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];
    desc = json['desc'];
    screenId = json['screenId'];
    groupId =
    json['groupId'] != null ? new GroupId.fromJson(json['groupId']) : null;
    soilType = json['soilType'] != null
        ? new SoilType.fromJson(json['soilType'])
        : null;
    status = json['status'];
    createdDate = json['createdDate'];
    docs = json['docs'];
    groupDetails = json['groupDetails'];
    if (json['soilAssessment'] != null) {
      soilAssessment = <SoilAssessment>[];
      json['soilAssessment'].forEach((v) {
        soilAssessment!.add(new SoilAssessment.fromJson(v));
      });
    }
    recommendedCrop = json['recommendedCrop'];
    mappingDetails = json['mappingDetails'];
    farmingGrowthFactorsRisks = json['farmingGrowthFactorsRisks'];
    yieldDet = json['yieldDet'];
    financeRequest = json['financeRequest'];
    selectOptionList = json['selectOptionList'];
    calenderEvents = json['calenderEvents'];
    agriInputEst = json['agriInputEst'];
    selectAppStatus = json['selectAppStatus'];
    sumInsured = json['sumInsured'];
    groupShare = json['groupShare'];
    groupPremiumAmt = json['groupPremiumAmt'];
    governmentShare = json['governmentShare'];
    governmentPrmAmt = json['governmentPrmAmt'];
    activateFromDate = json['activateFromDate'];
    activateToDate = json['activateToDate'];
    score = json['score'];
    cmOtherDocs = json['cmOtherDocs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reqSecureKey'] = this.reqSecureKey;
    data['addiParams'] = this.addiParams;
    if (this.chMessage != null) {
      data['chMessage'] = this.chMessage!.toJson();
    }
    data['urlDecision'] = this.urlDecision;
    data['id'] = this.id;
    data['farmingPlanId'] = this.farmingPlanId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['screenId'] = this.screenId;
    if (this.groupId != null) {
      data['groupId'] = this.groupId!.toJson();
    }
    if (this.soilType != null) {
      data['soilType'] = this.soilType!.toJson();
    }
    data['status'] = this.status;
    data['createdDate'] = this.createdDate;
    data['docs'] = this.docs;
    data['groupDetails'] = this.groupDetails;
    if (this.soilAssessment != null) {
      data['soilAssessment'] =
          this.soilAssessment!.map((v) => v.toJson()).toList();
    }
    data['recommendedCrop'] = this.recommendedCrop;
    data['mappingDetails'] = this.mappingDetails;
    data['farmingGrowthFactorsRisks'] = this.farmingGrowthFactorsRisks;
    data['yieldDet'] = this.yieldDet;
    data['financeRequest'] = this.financeRequest;
    data['selectOptionList'] = this.selectOptionList;
    data['calenderEvents'] = this.calenderEvents;
    data['agriInputEst'] = this.agriInputEst;
    data['selectAppStatus'] = this.selectAppStatus;
    data['sumInsured'] = this.sumInsured;
    data['groupShare'] = this.groupShare;
    data['groupPremiumAmt'] = this.groupPremiumAmt;
    data['governmentShare'] = this.governmentShare;
    data['governmentPrmAmt'] = this.governmentPrmAmt;
    data['activateFromDate'] = this.activateFromDate;
    data['activateToDate'] = this.activateToDate;
    data['score'] = this.score;
    data['cmOtherDocs'] = this.cmOtherDocs;
    return data;
  }
}


class GroupId {
  int? id;
  String? type;
  String? friendlyType;

  GroupId({this.id, this.type, this.friendlyType});

  GroupId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    friendlyType = json['friendlyType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['friendlyType'] = this.friendlyType;
    return data;
  }
}

class SoilType {
  Null? id;
  String? type;
  String? friendlyType;

  SoilType({this.id, this.type, this.friendlyType});

  SoilType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    friendlyType = json['friendlyType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['friendlyType'] = this.friendlyType;
    return data;
  }
}

class SoilAssessment {
  String? parameter;
  String? testValue;
  String? unit;
  String? rating;
  Null? id;
  Null? originalValue;

  SoilAssessment(
      {this.parameter,
        this.testValue,
        this.unit,
        this.rating,
        this.id,
        this.originalValue});

  SoilAssessment.fromJson(Map<String, dynamic> json) {
    parameter = json['parameter'];
    testValue = json['testValue'];
    unit = json['unit'];
    rating = json['rating'];
    id = json['id'];
    originalValue = json['originalValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parameter'] = this.parameter;
    data['testValue'] = this.testValue;
    data['unit'] = this.unit;
    data['rating'] = this.rating;
    data['id'] = this.id;
    data['originalValue'] = this.originalValue;
    return data;
  }
}


