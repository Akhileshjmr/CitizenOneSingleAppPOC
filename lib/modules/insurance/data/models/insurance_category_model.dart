import '../../domain/entities/insurance_category_entity.dart';

class InsuranceCategoryModel {
  final String code;
  final String name;
  final String? desc;
  final String? logo;
  final List<InsuranceSubCategoryModel> subCategories;

  InsuranceCategoryModel({
    required this.code,
    required this.name,
    this.desc,
    this.logo,
    required this.subCategories,
  });

  factory InsuranceCategoryModel.fromJson(Map<String, dynamic> json) {
    return InsuranceCategoryModel(
      code: json['code']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String?,
      logo: json['logo'] as String?,
      subCategories: (json['subCategories'] as List<dynamic>?)
              ?.map((s) =>
                  InsuranceSubCategoryModel.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  InsuranceCategoryEntity toEntity() {
    return InsuranceCategoryEntity(
      code: code,
      name: name,
      desc: desc,
      logo: logo,
      subCategories: subCategories.map((s) => s.toEntity()).toList(),
    );
  }
}

class InsuranceSubCategoryModel {
  final String code;
  final String name;
  final String? desc;
  final String? logo;

  InsuranceSubCategoryModel({
    required this.code,
    required this.name,
    this.desc,
    this.logo,
  });

  factory InsuranceSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return InsuranceSubCategoryModel(
      code: json['code']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String?,
      logo: json['logo'] as String?,
    );
  }

  InsuranceSubCategoryEntity toEntity() {
    return InsuranceSubCategoryEntity(
      code: code,
      name: name,
      desc: desc,
      logo: logo,
    );
  }
}

