class VehicleDetailsResponse {
  final ChMessage? chMessage;
  final VehicleData? data;

  VehicleDetailsResponse({
    this.chMessage,
    this.data,
  });

  factory VehicleDetailsResponse.fromJson(Map<String, dynamic> json) {
    return VehicleDetailsResponse(
      chMessage: json['chMessage'] != null
          ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      data: json['data'] != null
          ? VehicleData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chMessage': chMessage?.toJson(),
      'data': data?.toJson(),
    };
  }
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

class VehicleData {
  final String? id;
  final String? registrationNumber;
  final String? chassisNumber;
  final String? engineNumber;
  final String? make;
  final String? model;
  final int? yearOfManufacture;
  final String? color;
  final int? seatingCapacity;
  final double? sumInsured;
  final String? riskCategoryId;
  final RiskCategory? riskCategory;

  VehicleData({
    this.id,
    this.registrationNumber,
    this.chassisNumber,
    this.engineNumber,
    this.make,
    this.model,
    this.yearOfManufacture,
    this.color,
    this.seatingCapacity,
    this.sumInsured,
    this.riskCategoryId,
    this.riskCategory,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      id: json['id']?.toString(),
      registrationNumber: json['registrationNumber'] as String?,
      chassisNumber: json['chassisNumber'] as String?,
      engineNumber: json['engineNumber'] as String?,
      make: json['make'] as String?,
      model: json['model'] as String?,
      yearOfManufacture: json['yearOfManufacture'] as int?,
      color: json['color'] as String?,
      seatingCapacity: (json['seatingCapacity'] as num?)?.toInt(),
      sumInsured: (json['sumInsured'] as num?)?.toDouble(),
      riskCategoryId: json['riskCategoryId']?.toString(),
      riskCategory:
          json.containsKey('riskCategory') && json['riskCategory'] != null
              ? RiskCategory.fromJson(
                  json['riskCategory'] as Map<String, dynamic>,
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'chassisNumber': chassisNumber,
      'engineNumber': engineNumber,
      'make': make,
      'model': model,
      'yearOfManufacture': yearOfManufacture,
      'color': color,
      'seatingCapacity': seatingCapacity,
      'sumInsured': sumInsured,
      'riskCategoryId': riskCategoryId,
      if (riskCategory != null) 'riskCategory': riskCategory!.toJson(),
    };
  }

  VehicleData copyWith({
    String? id,
    String? registrationNumber,
    String? chassisNumber,
    String? engineNumber,
    String? make,
    String? model,
    int? yearOfManufacture,
    String? color,
    int? seatingCapacity,
    double? sumInsured,
    String? riskCategoryId,
    RiskCategory? riskCategory,
  }) {
    return VehicleData(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      engineNumber: engineNumber ?? this.engineNumber,
      make: make ?? this.make,
      model: model ?? this.model,
      yearOfManufacture: yearOfManufacture ?? this.yearOfManufacture,
      color: color ?? this.color,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      sumInsured: sumInsured ?? this.sumInsured,
      riskCategoryId: riskCategoryId ?? this.riskCategoryId,
      riskCategory: riskCategory ?? this.riskCategory,
    );
  }
}

class RiskCategory {
  final String? name;
  final String? description;
  final String? iconUrl;

  RiskCategory({
    this.name,
    this.description,
    this.iconUrl,
  });

  factory RiskCategory.fromJson(Map<String, dynamic> json) {
    return RiskCategory(
      name: json['name'] as String?,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
    };
  }

  RiskCategory copyWith({
    String? name,
    String? description,
    String? iconUrl,
  }) {
    return RiskCategory(
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }
}
