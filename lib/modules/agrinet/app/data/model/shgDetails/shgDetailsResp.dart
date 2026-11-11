import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../common/option.dart';

class FarmingPlanResponse {
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
  Group? groupId;
  String? soilType;
  String? status;
  DateTime? createdDate;
  dynamic docs;
  List<GroupDetail>? groupDetails;
  dynamic soilAssessment;
  List<RecommendedCrop>? recommendedCrop;
  dynamic mappingDetails;
  FarmingGrowthFactorsRisks? farmingGrowthFactorsRisks;
  List<YieldDet>? yieldDet;
  dynamic financeRequest;
  List<SelectOptionList>? selectOptionList;
  List<CalendarEvent>? calenderEvents;
  List<AgriInputEst>? agriInputEst;
  dynamic selectAppStatus;
  dynamic sumInsured;
  dynamic groupShare;
  dynamic groupPremiumAmt;
  dynamic governmentShare;
  dynamic governmentPrmAmt;
  DateTime? activateFromDate;
  DateTime? activateToDate;
  dynamic score;
  dynamic cmOtherDocs;

  FarmingPlanResponse({
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

  factory FarmingPlanResponse.fromJson(Map<String, dynamic> json) {
    return FarmingPlanResponse(
      reqSecureKey: _asString(json['reqSecureKey']),
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      id: _asString(json['id']),
      farmingPlanId: _asString(json['farmingPlanId']),
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      name: _asString(json['name']),
      desc: _asString(json['desc']),
      screenId: _asString(json['screenId']),
      groupId: json['groupId'] != null ? Group.fromJson(json['groupId']) : null,
      soilType: _asString(json['soilType']),
      status: _asString(json['status']),
      createdDate: _asDate(json['createdDate']),
      docs: json['docs'],
      groupDetails:
          json['groupDetails'] != null
              ? (json['groupDetails'] as List)
                  .map((i) => GroupDetail.fromJson(i))
                  .toList()
              : null,
      soilAssessment: json['soilAssessment'],
      recommendedCrop:
          json['recommendedCrop'] != null
              ? (json['recommendedCrop'] as List)
                  .map((i) => RecommendedCrop.fromJson(i))
                  .toList()
              : [],
      mappingDetails: json['mappingDetails'],
      farmingGrowthFactorsRisks:
          json['farmingGrowthFactorsRisks'] != null
              ? FarmingGrowthFactorsRisks.fromJson(
                json['farmingGrowthFactorsRisks'],
              )
              : null,
      yieldDet:
          json['yieldDet'] != null
              ? (json['yieldDet'] as List)
                  .map((item) => YieldDet.fromJson(item))
                  .toList()
              : null,
      financeRequest: json['financeRequest'],
      selectOptionList:
          json['selectOptionList'] != null
              ? (json['selectOptionList'] as List)
                  .map((i) => SelectOptionList.fromJson(i))
                  .toList()
              : null,
      calenderEvents:
          json['calenderEvents'] != null
              ? (json['calenderEvents'] as List)
                  .map((item) => CalendarEvent.fromJson(item))
                  .toList()
              : null,
      agriInputEst:
          json['agriInputEst'] != null
              ? (json['agriInputEst'] as List)
                  .map((e) => AgriInputEst.fromJson(e))
                  .toList()
              : null,
      selectAppStatus: json['selectAppStatus'],
      sumInsured: json['sumInsured'],
      groupShare: json['groupShare'],
      groupPremiumAmt: json['groupPremiumAmt'],
      governmentShare: json['governmentShare'],
      governmentPrmAmt: json['governmentPrmAmt'],
      activateFromDate: _asDate(json['activateFromDate']),
      activateToDate: _asDate(json['activateToDate']),
      score: json['score'],
      cmOtherDocs: json['cmOtherDocs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reqSecureKey': reqSecureKey,
      'addiParams': addiParams,
      'chMessage': chMessage?.toJson(),
      'urlDecision': urlDecision,
      'id': id,
      'farmingPlanId': farmingPlanId,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'desc': desc,
      'screenId': screenId,
      'groupId': groupId?.toJson(),
      'soilType': soilType,
      'status': status,
      'createdDate': createdDate?.toIso8601String(),
      'docs': docs,
      'groupDetails': groupDetails?.map((e) => e.toJson()).toList(),
      'soilAssessment': soilAssessment,
      'recommendedCrop': recommendedCrop?.map((e) => e.toJson()).toList(),
      'mappingDetails': mappingDetails,
      'farmingGrowthFactorsRisks': farmingGrowthFactorsRisks?.toJson(),
      'yieldDet': yieldDet?.map((item) => item.toJson()).toList(),
      'financeRequest': financeRequest,
      'selectOptionList': selectOptionList?.map((e) => e.toJson()).toList(),
      'calenderEvents': calenderEvents?.map((item) => item.toJson()).toList(),
      'agriInputEst': agriInputEst?.map((e) => e.toJson()).toList(),
      'selectAppStatus': selectAppStatus,
      'sumInsured': sumInsured,
      'groupShare': groupShare,
      'groupPremiumAmt': groupPremiumAmt,
      'governmentShare': governmentShare,
      'governmentPrmAmt': governmentPrmAmt,
      'activateFromDate': activateFromDate?.toIso8601String(),
      'activateToDate': activateToDate?.toIso8601String(),
      'score': score,
      'cmOtherDocs': cmOtherDocs,
    };
  }
}

// ---------------- YieldDet ----------------
class YieldDet {
  late RxString cropName;
  late RxString yieldkgOracre; // default → "0"
  late RxString yieldValue; // default → "0.0"
  dynamic id;
  late RxBool valueGiven; // default → false

  YieldDet({
    String cropName = '',
    String yieldkgOracre = '0',
    String yieldValue = '0.0',
    this.id,
    bool valueGiven = false,
  }) {
    this.cropName = cropName.obs;
    this.yieldkgOracre = yieldkgOracre.obs;
    this.yieldValue = yieldValue.obs;
    this.valueGiven = valueGiven.obs;
  }

  factory YieldDet.fromJson(Map<String, dynamic> json) {
    return YieldDet(
      cropName: json['cropName'] ?? '',
      yieldkgOracre: json['yieldkgOracre']?.toString() ?? '0',
      yieldValue: json['yieldValue']?.toString() ?? '0.0',
      id: json['id'],
      valueGiven: json['valueGiven'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName.value,
      'yieldkgOracre': double.tryParse(yieldkgOracre.value) ?? 0,
      'yieldValue': double.tryParse(yieldValue.value) ?? 0.0,
      'id': id,
      'valueGiven': valueGiven.value,
    };
  }
}

// ---------------- RecommendedCrop ----------------

class RecommendedCrop {
  String? cropName;
  RxBool recommended = false.obs;
  String? varienty;
  String? id;

  RecommendedCrop({this.cropName, bool? recommended, this.varienty, this.id}) {
    this.recommended.value = recommended ?? false;
  }

  factory RecommendedCrop.fromJson(Map<String, dynamic> json) {
    return RecommendedCrop(
      cropName: json['cropName'],
      recommended: json['recommended'] == true,
      varienty: json['varienty'],
      id: json['id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'recommended': recommended.value,
      'varienty': varienty,
      'id': id,
    };
  }
}

// ---------------- ChMessage ----------------

class ChMessage {
  String? code;
  String? message;
  String? type;
  String? dispType;
  bool? isError;
  String? subject;
  dynamic dataArr;

  ChMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
    this.dataArr,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) {
    return ChMessage(
      code: _asString(json['code']),
      message: _asString(json['message']),
      type: _asString(json['type']),
      dispType: _asString(json['dispType']),
      isError: json['isError'] is bool ? json['isError'] as bool : null,
      subject: _asString(json['subject']),
      dataArr: json['dataArr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'type': type,
      'dispType': dispType,
      'isError': isError,
      'subject': subject,
      'dataArr': dataArr,
    };
  }
}

// ---------------- Group ----------------

class Group {
  int? id;
  String? type;
  String? friendlyType;

  Group({this.id, this.type, this.friendlyType});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: _asInt(json['id']),
      type: _asString(json['type']),
      friendlyType: _asString(json['friendlyType']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'friendlyType': friendlyType};
  }
}

// ---------------- GroupDetail ----------------

class GroupDetail {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  Group? custId;
  String? custName;
  String? mobileNo;
  String? uniqueId;
  double? contribution;
  dynamic isChecked;
  int? id;
  List<LandDetail>? landDetails;

  GroupDetail({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.custId,
    this.custName,
    this.mobileNo,
    this.uniqueId,
    this.contribution,
    this.isChecked,
    this.id,
    this.landDetails,
  });

  factory GroupDetail.fromJson(Map<String, dynamic> json) {
    return GroupDetail(
      reqSecureKey: _asString(json['reqSecureKey']),
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      custId: json['custId'] != null ? Group.fromJson(json['custId']) : null,
      custName: _asString(json['custName']),
      mobileNo: _asString(json['mobileNo']),
      uniqueId: _asString(json['uniqueId']),
      contribution: _asDouble(json['contribution']),
      isChecked: json['isChecked'],
      id: _asInt(json['id']),
      landDetails:
          json['landDetails'] != null
              ? (json['landDetails'] as List)
                  .map((i) => LandDetail.fromJson(i))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reqSecureKey': reqSecureKey,
      'addiParams': addiParams,
      'chMessage': chMessage?.toJson(),
      'urlDecision': urlDecision,
      'custId': custId?.toJson(),
      'custName': custName,
      'mobileNo': mobileNo,
      'uniqueId': uniqueId,
      'contribution': contribution,
      'isChecked': isChecked,
      'id': id,
      'landDetails': landDetails?.map((e) => e.toJson()).toList(),
    };
  }
}

// ---------------- LandDetail ----------------

class LandDetail {
  String? village;
  double? ownedArea;
  double? leasedArea;
  double? irrigatedPerc;
  String? sourceOfIrrigation;
  int? landId;
  bool? isChecked;
  double? farmValue;
  int? contribution;
  String? areaUnit;

  LandDetail({
    this.village,
    this.ownedArea,
    this.leasedArea,
    this.irrigatedPerc,
    this.sourceOfIrrigation,
    this.landId,
    this.isChecked,
    this.farmValue,
    this.contribution,
    this.areaUnit,
  });

  factory LandDetail.fromJson(Map<String, dynamic> json) {
    return LandDetail(
      village: _asString(json['village']),
      ownedArea: _asDouble(json['ownedArea']),
      leasedArea: _asDouble(json['leasedArea']),
      irrigatedPerc: _asDouble(json['irrigatedPerc']),
      sourceOfIrrigation: _asString(json['sourceOfIrrigation']),
      landId: _asInt(json['landId']),
      isChecked: json['isChecked'] is bool ? json['isChecked'] as bool : null,
      farmValue: _asDouble(json['farmValue']),
      contribution: _asInt(json['contribution']),
      areaUnit: _asString(json['areaUnit']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village': village,
      'ownedArea': ownedArea,
      'leasedArea': leasedArea,
      'irrigatedPerc': irrigatedPerc,
      'sourceOfIrrigation': sourceOfIrrigation,
      'landId': landId,
      'isChecked': isChecked,
      'farmValue': farmValue,
      'contribution': contribution,
      'areaUnit': areaUnit,
    };
  }

  // ---------- SAFE PARSERS ----------
  static String? _asString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt(); // 889.0 → 889
    return int.tryParse(value.toString());
  }
}

// ---------------- SelectOptionList ----------------

class SelectOptionList {
  String? key;
  List<Option>? options;

  SelectOptionList({this.key, this.options});

  factory SelectOptionList.fromJson(Map<String, dynamic> json) {
    return SelectOptionList(
      key: _asString(json['key']),
      options:
          json['options'] != null
              ? (json['options'] as List)
                  .map((i) => Option.fromJson(i))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'options': options?.map((e) => e.toJson()).toList()};
  }
}

// ---------- Helper converters ----------

String? _asString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  if (value is Map) {
    // Try common inner keys, then fallback
    for (final key in ['id', 'value', 'code', 'name']) {
      if (value[key] != null) {
        return value[key].toString();
      }
    }
    return value.toString();
  }
  return value.toString();
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

DateTime? _asDate(dynamic value) {
  if (value == null) return null;

  if (value is DateTime) return value;

  if (value is String) {
    return DateTime.tryParse(value);
  }

  if (value is int) {
    // Assume milliseconds since epoch
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  if (value is Map<String, dynamic>) {
    // Common formats: { "time": 1717433543000 } or { "timestamp": "2024-10-01T10:20:30Z" }
    final time = value['time'] ?? value['timestamp'];
    if (time is int) {
      return DateTime.fromMillisecondsSinceEpoch(time);
    }
    if (time is String) {
      // Try parse direct or as milliseconds
      final parsed = DateTime.tryParse(time);
      if (parsed != null) return parsed;
      final ms = int.tryParse(time);
      if (ms != null) {
        return DateTime.fromMillisecondsSinceEpoch(ms);
      }
    }
  }

  return null;
}

class FarmingGrowthFactorsRisks {
  Option? climaticConditions;
  Option? soilFertility;
  Option? seedQuality;
  Option? fertilizersUsage;
  Option? pestiOrChemUsage;
  Option? irrigationMethod;
  Option? irrigationCoverage;
  Option? agroEquipmentAvail;
  Option? accessToCredit;
  Option? labourAvailability;
  Option? forecastedYield;
  Option? electricitySupply;
  Option? storageAvailability;
  Option? transportationAvail;
  Option? harvestMarketing;

  FarmingGrowthFactorsRisks({
    this.climaticConditions,
    this.soilFertility,
    this.seedQuality,
    this.fertilizersUsage,
    this.pestiOrChemUsage,
    this.irrigationMethod,
    this.irrigationCoverage,
    this.agroEquipmentAvail,
    this.accessToCredit,
    this.labourAvailability,
    this.forecastedYield,
    this.electricitySupply,
    this.storageAvailability,
    this.transportationAvail,
    this.harvestMarketing,
  });

  factory FarmingGrowthFactorsRisks.fromJson(Map<String, dynamic> json) {
    return FarmingGrowthFactorsRisks(
      climaticConditions:
          json['climaticConditions'] != null
              ? Option.fromJson(json['climaticConditions'])
              : null,
      soilFertility:
          json['soilFertility'] != null
              ? Option.fromJson(json['soilFertility'])
              : null,
      seedQuality:
          json['seedQuality'] != null
              ? Option.fromJson(json['seedQuality'])
              : null,
      fertilizersUsage:
          json['fertilizersUsage'] != null
              ? Option.fromJson(json['fertilizersUsage'])
              : null,
      pestiOrChemUsage:
          json['pestiOrChemUsage'] != null
              ? Option.fromJson(json['pestiOrChemUsage'])
              : null,
      irrigationMethod:
          json['irrigationMethod'] != null
              ? Option.fromJson(json['irrigationMethod'])
              : null,
      irrigationCoverage:
          json['irrigationCoverage'] != null
              ? Option.fromJson(json['irrigationCoverage'])
              : null,
      agroEquipmentAvail:
          json['agroEquipmentAvail'] != null
              ? Option.fromJson(json['agroEquipmentAvail'])
              : null,
      accessToCredit:
          json['accessToCredit'] != null
              ? Option.fromJson(json['accessToCredit'])
              : null,
      labourAvailability:
          json['labourAvailability'] != null
              ? Option.fromJson(json['labourAvailability'])
              : null,
      forecastedYield:
          json['forecastedYield'] != null
              ? Option.fromJson(json['forecastedYield'])
              : null,
      electricitySupply:
          json['electricitySupply'] != null
              ? Option.fromJson(json['electricitySupply'])
              : null,
      storageAvailability:
          json['storageAvailability'] != null
              ? Option.fromJson(json['storageAvailability'])
              : null,
      transportationAvail:
          json['transportationAvail'] != null
              ? Option.fromJson(json['transportationAvail'])
              : null,
      harvestMarketing:
          json['harvestMarketing'] != null
              ? Option.fromJson(json['harvestMarketing'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'climaticConditions': climaticConditions?.toJson(),
      'soilFertility': soilFertility?.toJson(),
      'seedQuality': seedQuality?.toJson(),
      'fertilizersUsage': fertilizersUsage?.toJson(),
      'pestiOrChemUsage': pestiOrChemUsage?.toJson(),
      'irrigationMethod': irrigationMethod?.toJson(),
      'irrigationCoverage': irrigationCoverage?.toJson(),
      'agroEquipmentAvail': agroEquipmentAvail?.toJson(),
      'accessToCredit': accessToCredit?.toJson(),
      'labourAvailability': labourAvailability?.toJson(),
      'forecastedYield': forecastedYield?.toJson(),
      'electricitySupply': electricitySupply?.toJson(),
      'storageAvailability': storageAvailability?.toJson(),
      'transportationAvail': transportationAvail?.toJson(),
      'harvestMarketing': harvestMarketing?.toJson(),
    };
  }
}

class CalendarEvent {
  dynamic farmPlanId;
  dynamic eventType;
  String? activity1;
  int? eventDate;
  dynamic eventDesc;
  String? weekName;
  int? days;
  dynamic activity2;
  dynamic cropStage;
  dynamic remark;
  String? integraAndInterfaces;
  String? cropName;
  int? id;

  CalendarEvent({
    this.farmPlanId,
    this.eventType,
    this.activity1,
    this.eventDate,
    this.eventDesc,
    this.weekName,
    this.days,
    this.activity2,
    this.cropStage,
    this.remark,
    this.integraAndInterfaces,
    this.cropName,
    this.id,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      farmPlanId: json['farmPlanId'],
      eventType: json['eventType'],
      activity1: json['activity1'],
      eventDate: json['eventDate'],
      eventDesc: json['eventDesc'],
      weekName: json['weekName'],
      days: json['days'],
      activity2: json['activity2'],
      cropStage: json['cropStage'],
      remark: json['remark'],
      integraAndInterfaces: json['integraAndInterfaces'],
      cropName: json['cropName'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmPlanId': farmPlanId,
      'eventType': eventType,
      'activity1': activity1,
      'eventDate': eventDate,
      'eventDesc': eventDesc,
      'weekName': weekName,
      'days': days,
      'activity2': activity2,
      'cropStage': cropStage,
      'remark': remark,
      'integraAndInterfaces': integraAndInterfaces,
      'cropName': cropName,
      'id': id,
    };
  }

  // Helper method to convert eventDate timestamp to DateTime
  DateTime? get eventDateTime {
    if (eventDate == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(eventDate!);
  }

  // Helper method to format event date
  String get formattedEventDate {
    if (eventDateTime == null) return '';
    return '${eventDateTime!.day}/${eventDateTime!.month}/${eventDateTime!.year}';
  }
}

class AgriInputEst {
  final int id;
  final Category category;
  final Common common;
  final String unitType;
  String? estQuantity;
  final String? palsInput;
  String comments;

  AgriInputEst({
    required this.id,
    required this.category,
    required this.common,
    required this.unitType,
    required this.estQuantity,
    required this.palsInput,
    required this.comments,
  });

  factory AgriInputEst.fromJson(Map<String, dynamic> json) {
    return AgriInputEst(
      id: json['id'] ?? 0,
      category: Category.fromJson(json['category']),
      common: Common.fromJson(json['common']),
      unitType: json['unitType'] ?? '',
      estQuantity: json['estQuantity'],
      palsInput: json['palsInput'],
      comments: json['comments'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.toJson(),
      'common': common.toJson(),
      'unitType': unitType,
      'estQuantity': estQuantity,
      'palsInput': palsInput,
      'comments': comments,
    };
  }
}

class Category {
  final int id;
  final String type;
  final String friendlyType;

  Category({required this.id, required this.type, required this.friendlyType});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      friendlyType: json['friendlyType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'friendlyType': friendlyType};
  }
}

class Common {
  final int id;
  final String type;
  final String friendlyType;

  Common({required this.id, required this.type, required this.friendlyType});

  factory Common.fromJson(Map<String, dynamic> json) {
    return Common(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      friendlyType: json['friendlyType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'friendlyType': friendlyType};
  }
}
