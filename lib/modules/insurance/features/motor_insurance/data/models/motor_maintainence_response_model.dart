class MotorMaintainenceResponseModel {
  final ChMessage? chMessage;
  final MotorMaintenanceData? data;

  MotorMaintainenceResponseModel({
    this.chMessage,
    this.data,
  });

  factory MotorMaintainenceResponseModel.fromJson(Map<String, dynamic> json) {
    return MotorMaintainenceResponseModel(
        chMessage: json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
            : null,
        data: MotorMaintenanceData.fromJson(json));
  }

  Map<String, dynamic> toJson() => {
        'chMessage': chMessage?.toJson(),
        'data': data?.toJson(),
      };
}

class MotorMaintenanceData {
  final String? reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final List<BodyStyle> bodyStyles;
  final List<VehicleMake> vehicleMakes;
  final List<PolicyDuration> policyDurations;
  final List<PlanType> planTypes;

  MotorMaintenanceData({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    required this.bodyStyles,
    required this.vehicleMakes,
    required this.policyDurations,
    required this.planTypes,
  });

  factory MotorMaintenanceData.fromJson(Map<String, dynamic> json) {
    return MotorMaintenanceData(
      reqSecureKey: json['reqSecureKey'] as String?,
      addiParams: json['addiParams'],
      chMessage: json['chMessage'] != null
          ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      urlDecision: json['urlDecision'],
      bodyStyles: (json['bodyStyles'] as List<dynamic>? ?? [])
          .map((e) => BodyStyle.fromJson(e as Map<String, dynamic>))
          .toList(),
      vehicleMakes: (json['vehicleMakes'] as List<dynamic>? ?? [])
          .map((e) => VehicleMake.fromJson(e as Map<String, dynamic>))
          .toList(),
      policyDurations: (json['policyDurations'] as List<dynamic>? ?? [])
          .map((e) => PolicyDuration.fromJson(e as Map<String, dynamic>))
          .toList(),
      planTypes: (json['planTypes'] as List<dynamic>? ?? [])
          .map((e) => PlanType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'reqSecureKey': reqSecureKey,
        'addiParams': addiParams,
        'chMessage': chMessage?.toJson(),
        'urlDecision': urlDecision,
        'bodyStyles': bodyStyles.map((e) => e.toJson()).toList(),
        'vehicleMakes': vehicleMakes.map((e) => e.toJson()).toList(),
        'policyDurations': policyDurations.map((e) => e.toJson()).toList(),
        'planTypes': planTypes.map((e) => e.toJson()).toList(),
      };
}

class ChMessage {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool? isError;
  final String? subject;
  final dynamic dataArr;

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
      code: json['code'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      dispType: json['dispType'] as String?,
      isError: json['isError'] as bool?,
      subject: json['subject'] as String?,
      dataArr: json['dataArr'],
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'type': type,
        'dispType': dispType,
        'isError': isError,
        'subject': subject,
        'dataArr': dataArr,
      };
}

class BodyStyle {
  final int? id;
  final String? name;
  final String? imageUrl;

  BodyStyle({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory BodyStyle.fromJson(Map<String, dynamic> json) {
    return BodyStyle(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      };
}

class VehicleMake {
  final int? id;
  final String? name;

  VehicleMake({
    this.id,
    this.name,
  });

  factory VehicleMake.fromJson(Map<String, dynamic> json) {
    return VehicleMake(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class PolicyDuration {
  final int? id;
  final int? quarters;
  final int? months;

  PolicyDuration({
    this.id,
    this.quarters,
    this.months,
  });

  factory PolicyDuration.fromJson(Map<String, dynamic> json) {
    return PolicyDuration(
      id: json['id'] as int?,
      quarters: json['quarters'] as int?,
      months: json['months'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quarters': quarters,
        'months': months,
      };
}

class PlanType {
  final String? key;
  final String? value;

  PlanType({
    this.key,
    this.value,
  });

  factory PlanType.fromJson(Map<String, dynamic> json) {
    return PlanType(
      key: json['key'] as String?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };
}
