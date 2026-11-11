import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_maintainence_response_model.dart';

class MotorProductDetailsResponseModel {
  final ChMessage? chMessage;
  final MotorProductData? data;

  MotorProductDetailsResponseModel({
    this.chMessage,
    this.data,
  });

  factory MotorProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return MotorProductDetailsResponseModel(
      chMessage: json['chMessage'] != null
          ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      data: json['data'] != null
          ? MotorProductData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'chMessage': chMessage?.toJson(),
        'data': data?.toJson(),
      };
}

class MotorProductData {
  final String? id;
  final String? productType;
  final String? durationType;
  final List<dynamic>? policyClauses;
  final List<MotorProductDocument>? documents;
  final MotorProductInsurer? insurer;
  final String? createdAt;
  final String? updatedAt;
  final dynamic additionalProperties;

  MotorProductData({
    this.id,
    this.productType,
    this.durationType,
    this.policyClauses,
    this.documents,
    this.insurer,
    this.createdAt,
    this.updatedAt,
    this.additionalProperties,
  });

  factory MotorProductData.fromJson(Map<String, dynamic> json) {
    return MotorProductData(
      id: json['id'] as String?,
      productType: json['productType'] as String?,
      durationType: json['durationType'] as String?,
      policyClauses: json['policyClauses'] as List<dynamic>?,
      documents: json['documents'] != null
          ? (json['documents'] as List<dynamic>)
              .map((e) => MotorProductDocument.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      insurer: json['insurer'] != null
          ? MotorProductInsurer.fromJson(json['insurer'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      additionalProperties: json['additionalProperties'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productType': productType,
        'durationType': durationType,
        'policyClauses': policyClauses,
        'documents': documents?.map((e) => e.toJson()).toList(),
        'insurer': insurer?.toJson(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'additionalProperties': additionalProperties,
      };
}

class MotorProductDocument {
  final String? id;
  final String? name;
  final String? url;
  final String? riskCategoryId;
  final String? productId;

  MotorProductDocument({
    this.id,
    this.name,
    this.url,
    this.riskCategoryId,
    this.productId,
  });

  factory MotorProductDocument.fromJson(Map<String, dynamic> json) {
    return MotorProductDocument(
      id: json['id'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      riskCategoryId: json['riskCategoryId'] as String?,
      productId: json['productId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'riskCategoryId': riskCategoryId,
        'productId': productId,
      };
}

class MotorProductInsurer {
  final String? id;
  final String? name;
  final String? shortName;
  final String? logoUrl;
  final MotorProductAddress? address;
  final String? email;

  MotorProductInsurer({
    this.id,
    this.name,
    this.shortName,
    this.logoUrl,
    this.address,
    this.email,
  });

  factory MotorProductInsurer.fromJson(Map<String, dynamic> json) {
    return MotorProductInsurer(
      id: json['id'] as String?,
      name: json['name'] as String?,
      shortName: json['shortName'] as String?,
      logoUrl: json['logoUrl'] as String?,
      address: json['address'] != null
          ? MotorProductAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'shortName': shortName,
        'logoUrl': logoUrl,
        'address': address?.toJson(),
        'email': email,
      };
}

class MotorProductAddress {
  final String? country;
  final String? province;
  final String? district;
  final String? street;
  final String? plotNo;

  MotorProductAddress({
    this.country,
    this.province,
    this.district,
    this.street,
    this.plotNo,
  });

  factory MotorProductAddress.fromJson(Map<String, dynamic> json) {
    return MotorProductAddress(
      country: json['country'] as String?,
      province: json['province'] as String?,
      district: json['district'] as String?,
      street: json['street'] as String?,
      plotNo: json['plotNo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'country': country,
        'province': province,
        'district': district,
        'street': street,
        'plotNo': plotNo,
      };
}
