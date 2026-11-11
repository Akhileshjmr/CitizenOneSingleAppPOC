import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/create_individual_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/quotation_response_model.dart'
    hide ChMessage;

class IssuePolicyByQuoteIdResponse {
  final ChMessage? chMessage;
  final PolicyData? data;

  IssuePolicyByQuoteIdResponse({
    this.chMessage,
    this.data,
  });

  factory IssuePolicyByQuoteIdResponse.fromJson(Map<String, dynamic> json) {
    return IssuePolicyByQuoteIdResponse(
      chMessage: json['chMessage'] is Map<String, dynamic>
          ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      data: json['data'] is Map<String, dynamic>
          ? PolicyData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'chMessage': chMessage?.toJson(),
        'data': data?.toJson(),
      };
}

class PolicyData {
  final Client? client;
  final String? policyNumber;
  final String? status;
  final String? premiumStatus;
  final String? approvedDate;
  final String? startDate;
  final String? endDate;
  final String? currency;
  final double? premiumLevy;
  final double? basicPremium;
  final double? grossPremium;
  final Product? product;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? transactionNumber;
  final String? quotationId;
  final double? gatewayCharge;
  final double? platformCharge;
  final double? totalPayable;
  final String? gatewayChargeType;
  final double? gatewayChargeValue;
  final String? platformChargeType;
  final double? platformChargeValue;
  final String? referenceNumber;
  final String? hostReferenceNumber;

  PolicyData(
      {this.client,
      this.policyNumber,
      this.status,
      this.premiumStatus,
      this.approvedDate,
      this.startDate,
      this.endDate,
      this.currency,
      this.premiumLevy,
      this.basicPremium,
      this.grossPremium,
      this.product,
      this.id,
      this.createdAt,
      this.updatedAt,
      this.transactionNumber,
      this.quotationId,
      this.gatewayCharge,
      this.platformCharge,
      this.totalPayable,
      this.gatewayChargeType,
      this.gatewayChargeValue,
      this.platformChargeType,
      this.platformChargeValue,
      this.hostReferenceNumber,
      this.referenceNumber});

  factory PolicyData.fromJson(Map<String, dynamic> json) {
    return PolicyData(
      client: json['client'] is Map<String, dynamic>
          ? Client.fromJson(json['client'] as Map<String, dynamic>)
          : null,
      policyNumber: _string(json['policyNumber']),
      status: _string(json['status']),
      premiumStatus: _string(json['premiumStatus']),
      approvedDate: _string(json['approvedDate']),
      startDate: _string(json['startDate']),
      endDate: _string(json['endDate']),
      currency: _string(json['currency']),
      premiumLevy: _double(json['premiumLevy']),
      basicPremium: _double(json['basicPremium']),
      grossPremium: _double(json['grossPremium']),
      product: json['product'] is Map<String, dynamic>
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      id: _string(json['id']),
      createdAt: _string(json['createdAt']),
      updatedAt: _string(json['updatedAt']),
      transactionNumber: _string(json['transactionNumber']),
      quotationId: _string(json['quotationId']),
      gatewayCharge: _double(json['gatewayCharge']),
      platformCharge: _double(json['platformCharge']),
      totalPayable: _double(json['totalPayable']),
      gatewayChargeType: _string(json['gatewayChargeType']),
      gatewayChargeValue: _double(json['gatewayChargeValue']),
      platformChargeType: _string(json['platformChargeType']),
      platformChargeValue: _double(json['platformChargeValue']),
      hostReferenceNumber:
          json['hostRefNumber'] != null ? _string(json['hostRefNumber']) : 'NA',
      referenceNumber: json['referenceNumber'] != null
          ? _string(json['referenceNumber'])
          : 'NA',
    );
  }

  Map<String, dynamic> toJson() => {};
}

class Client {
  final String? name;
  final String? identificationNumber;
  final String? email;
  final String? phoneNumber;
  final String? physicalAddress;
  final String? type;
  final String? status;
  final String? taxPayerId;
  final String? dateOfBirth;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  Client({
    this.name,
    this.identificationNumber,
    this.email,
    this.phoneNumber,
    this.physicalAddress,
    this.type,
    this.status,
    this.taxPayerId,
    this.dateOfBirth,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: _string(json['name']),
      identificationNumber: _string(json['identificationNumber']),
      email: _string(json['email']),
      phoneNumber: _string(json['phoneNumber']),
      physicalAddress: _string(json['physicalAddress']),
      type: _string(json['type']),
      status: _string(json['status']),
      taxPayerId: _string(json['taxPayerId']),
      dateOfBirth: _string(json['dateOfBirth']),
      id: _string(json['id']),
      createdAt: _string(json['createdAt']),
      updatedAt: _string(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {};
}

class Product {
  final String? name;
  final String? description;
  final String? code;
  final String? source;
  final String? partnerId;
  final Insurer? insurer;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  Product({
    this.name,
    this.description,
    this.code,
    this.source,
    this.partnerId,
    this.insurer,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: _string(json['name']),
      description: _string(json['description']),
      code: _string(json['code']),
      source: _string(json['source']),
      partnerId: _string(json['partnerId']),
      insurer: json['insurer'] is Map<String, dynamic>
          ? Insurer.fromJson(json['insurer'] as Map<String, dynamic>)
          : null,
      id: _string(json['id']),
      createdAt: _string(json['createdAt']),
      updatedAt: _string(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {};
}

class Address {
  final String? country;
  final String? province;
  final String? district;
  final String? street;
  final String? plotNo;

  Address({
    this.country,
    this.province,
    this.district,
    this.street,
    this.plotNo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      country: _string(json['country']),
      province: _string(json['province']),
      district: _string(json['district']),
      street: _string(json['street']),
      plotNo: _string(json['plotNo']),
    );
  }

  Map<String, dynamic> toJson() => {};
}

/// Helpers
String? _string(dynamic value) => value?.toString();

double? _double(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
