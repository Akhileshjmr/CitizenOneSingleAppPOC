import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_details_response_model.dart';

class QuotationCompareEntity {
  final String productType;
  final String currency;
  final int duration;
  final String durationType;
  final String startDate;
  final PolicyHolderEntity policyHolder;
  final List<VehicleData> risks;

  const QuotationCompareEntity({
    required this.productType,
    required this.currency,
    required this.duration,
    required this.durationType,
    required this.startDate,
    required this.policyHolder,
    required this.risks,
  });

  Map<String, dynamic> toJson() {
    return {
      'productType': productType,
      'currency': currency,
      'duration': duration,
      'durationType': durationType,
      'startDate': startDate,
      'policyHolder': policyHolder.toJson(),
      'risks': risks.map((e) => e.toJson()).toList(),
    };
  }
}

class PolicyHolderEntity {
  final String type;
  final String name;
  final String phone;
  final String physicalAddress;
  final String email;
  final String idType;
  final String idNumber;

  const PolicyHolderEntity({
    required this.type,
    required this.name,
    required this.phone,
    required this.physicalAddress,
    required this.email,
    required this.idType,
    required this.idNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'phone': phone,
      'physicalAddress': physicalAddress,
      'email': email,
      'idType': idType,
      'idNumber': idNumber,
    };
  }
}

class RiskEntity {
  final String make;
  final String model;
  final int yearOfManufacture;
  final String seatingcapacity;
  final int tonnage;
  final List<String> photosUrls;
  final String registrationNumber;
  final String chassisNumber;
  final String engineNumber;
  final int sumInsured;
  final String currency;
  final String color;
  final String motorRiskCategoryId;
  final String? motorBodyTypeId;

  const RiskEntity({
    required this.make,
    required this.model,
    required this.yearOfManufacture,
    required this.seatingcapacity,
    required this.tonnage,
    required this.photosUrls,
    required this.registrationNumber,
    required this.chassisNumber,
    required this.engineNumber,
    required this.sumInsured,
    required this.currency,
    required this.color,
    required this.motorRiskCategoryId,
    this.motorBodyTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'make': make,
      'model': model,
      'yearOfManufacture': yearOfManufacture,
      'seatingcapacity': seatingcapacity,
      'tonnage': tonnage,
      'photosUrls': photosUrls,
      'registrationNumber': registrationNumber,
      'chassisNumber': chassisNumber,
      'engineNumber': engineNumber,
      'sumInsured': sumInsured,
      'currency': currency,
      'color': color,
      'motorRiskCategoryId': motorRiskCategoryId,
      'motorBodyTypeId': motorBodyTypeId,
    };
  }
}
