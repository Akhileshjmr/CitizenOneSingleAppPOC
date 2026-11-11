import '../../domain/entities/insurance_partner_entity.dart';

class InsurancePartnerModel {
  final String vendorName;
  final String vendorCode;
  final String vendorDesc;
  final String vendorLogo;
  final String vendorKey;
  final String vendorMob;

  const InsurancePartnerModel({
    required this.vendorName,
    required this.vendorCode,
    required this.vendorDesc,
    required this.vendorLogo,
    required this.vendorKey,
    required this.vendorMob,
  });

  factory InsurancePartnerModel.fromJson(Map<String, dynamic> json) {
    return InsurancePartnerModel(
      vendorName: json['vendorName'] as String? ?? '',
      vendorCode: json['vendorCode'] as String? ?? '',
      vendorDesc: json['vendorDesc'] as String? ?? '',
      vendorLogo: json['vendorLogo'] as String? ?? '',
      vendorKey: json['vendorKey'] as String? ?? '',
      vendorMob: json['vendorMob'] as String? ?? '',
    );
  }

  InsurancePartnerEntity toEntity() {
    return InsurancePartnerEntity(
      vendorName: vendorName,
      vendorCode: vendorCode,
      vendorDesc: vendorDesc,
      vendorLogo: vendorLogo,
      vendorKey: vendorKey,
      vendorMob: vendorMob,
    );
  }
}

