import '../../domain/entities/insurance_plan_entity.dart';

class InsurancePlanModel {
  final String id;
  final String title;
  final String company;
  final String premium;
  final String cover;
  final String claim;
  final String network;
  final String highlight;
  final String categoryCode;

  const InsurancePlanModel({
    required this.id,
    required this.title,
    required this.company,
    required this.premium,
    required this.cover,
    required this.claim,
    required this.network,
    required this.highlight,
    this.categoryCode = 'HEALTH',
  });

  factory InsurancePlanModel.fromJson(Map<String, dynamic> json) {
    return InsurancePlanModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      premium: json['premium'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
      claim: json['claim'] as String? ?? '',
      network: json['network'] as String? ?? '',
      highlight: json['highlight'] as String? ?? '',
      categoryCode: json['categoryCode'] as String? ?? 'HEALTH',
    );
  }

  InsurancePlanEntity toEntity() {
    return InsurancePlanEntity(
      id: id,
      title: title,
      company: company,
      premium: premium,
      cover: cover,
      claimRatio: claim,
      network: network,
      highlight: highlight,
      categoryCode: categoryCode,
    );
  }
}

