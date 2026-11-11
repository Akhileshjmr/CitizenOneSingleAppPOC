import '../common/ch_message.dart';

class FarmPlansResp {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;

  String? id;
  String? farmingPlanId;

  double? latitude;
  double? longitude;

  String? name;
  String? desc;
  String? screenId;

  String? groupId;
  String? soilType;
  String? status;

  String? createdDate;

  dynamic docs;
  dynamic groupDetails;
  dynamic soilAssessment;
  dynamic recommendedCrop;
  dynamic mappingDetails;
  dynamic farmingGrowthFactorsRisks;
  dynamic yieldDet;
  dynamic financeRequest;
  dynamic selectOptionList;
  dynamic calenderEvents;
  dynamic agriInputEst;

  List<SelectAppStatus>? selectAppStatus;

  double? sumInsured;
  double? groupShare;
  double? groupPremiumAmt;
  double? governmentShare;
  double? governmentPrmAmt;

  String? activateFromDate;
  String? activateToDate;

  int? score;

  dynamic cmOtherDocs;

  FarmPlansResp({
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
    this.cmOtherDocs,
  });

  FarmPlansResp.fromJson(Map<String, dynamic> json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];

    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;

    urlDecision = json['urlDecision'];

    id = json['id']?.toString();
    farmingPlanId = json['farmingPlanId']?.toString();

    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();

    name = json['name'];
    desc = json['desc'];
    screenId = json['screenId'];

    groupId = json['groupId']?.toString();
    soilType = json['soilType'];
    status = json['status'];

    createdDate = json['createdDate'];

    docs = json['docs'];
    groupDetails = json['groupDetails'];
    soilAssessment = json['soilAssessment'];
    recommendedCrop = json['recommendedCrop'];
    mappingDetails = json['mappingDetails'];
    farmingGrowthFactorsRisks = json['farmingGrowthFactorsRisks'];
    yieldDet = json['yieldDet'];
    financeRequest = json['financeRequest'];
    selectOptionList = json['selectOptionList'];
    calenderEvents = json['calenderEvents'];
    agriInputEst = json['agriInputEst'];

    if (json['selectAppStatus'] != null) {
      selectAppStatus =
          (json['selectAppStatus'] as List)
              .map((e) => SelectAppStatus.fromJson(e))
              .toList();
    }

    sumInsured = json['sumInsured']?.toDouble();
    groupShare = json['groupShare']?.toDouble();
    groupPremiumAmt = json['groupPremiumAmt']?.toDouble();
    governmentShare = json['governmentShare']?.toDouble();
    governmentPrmAmt = json['governmentPrmAmt']?.toDouble();

    activateFromDate = json['activateFromDate'];
    activateToDate = json['activateToDate'];

    score = json['score']; // ✅ int

    cmOtherDocs = json['cmOtherDocs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['reqSecureKey'] = reqSecureKey;
    data['addiParams'] = addiParams;

    if (chMessage != null) {
      data['chMessage'] = chMessage!.toJson();
    }

    data['urlDecision'] = urlDecision;
    data['id'] = id;
    data['farmingPlanId'] = farmingPlanId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['name'] = name;
    data['desc'] = desc;
    data['screenId'] = screenId;
    data['groupId'] = groupId;
    data['soilType'] = soilType;
    data['status'] = status;
    data['createdDate'] = createdDate;
    data['docs'] = docs;
    data['groupDetails'] = groupDetails;
    data['soilAssessment'] = soilAssessment;
    data['recommendedCrop'] = recommendedCrop;
    data['mappingDetails'] = mappingDetails;
    data['farmingGrowthFactorsRisks'] = farmingGrowthFactorsRisks;
    data['yieldDet'] = yieldDet;
    data['financeRequest'] = financeRequest;
    data['selectOptionList'] = selectOptionList;
    data['calenderEvents'] = calenderEvents;
    data['agriInputEst'] = agriInputEst;

    if (selectAppStatus != null) {
      data['selectAppStatus'] =
          selectAppStatus!.map((v) => v.toJson()).toList();
    }

    data['sumInsured'] = sumInsured;
    data['groupShare'] = groupShare;
    data['groupPremiumAmt'] = groupPremiumAmt;
    data['governmentShare'] = governmentShare;
    data['governmentPrmAmt'] = governmentPrmAmt;
    data['activateFromDate'] = activateFromDate;
    data['activateToDate'] = activateToDate;
    data['score'] = score;
    data['cmOtherDocs'] = cmOtherDocs;

    return data;
  }
}

/* -------------------------------- */

class SelectAppStatus {
  String? key;
  List<AgriFramdet>? agriFramdet;

  SelectAppStatus({this.key, this.agriFramdet});

  SelectAppStatus.fromJson(Map<String, dynamic> json) {
    key = json['key'];

    if (json['agriFramdet'] != null) {
      agriFramdet =
          (json['agriFramdet'] as List)
              .map((e) => AgriFramdet.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['key'] = key;

    if (agriFramdet != null) {
      data['agriFramdet'] = agriFramdet!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

/* -------------------------------- */

class AgriFramdet {
  String? groupName;
  String? planName;
  String? planId;
  String? groupId;
  int? score;
  String? appStatus;
  bool? wfStart;

  AgriFramdet({
    this.groupName,
    this.planName,
    this.planId,
    this.groupId,
    this.score,
    this.appStatus,
    this.wfStart,
  });

  AgriFramdet.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    planName = json['planName'];
    planId = json['planId'];
    groupId = json['groupId']?.toString();
    score = json['score'];
    appStatus = json['appStatus'];
    wfStart = json['wfStart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['groupName'] = groupName;
    data['planName'] = planName;
    data['planId'] = planId;
    data['groupId'] = groupId;
    data['score'] = score;
    data['appStatus'] = appStatus;
    data['wfStart'] = wfStart;

    return data;
  }
}
