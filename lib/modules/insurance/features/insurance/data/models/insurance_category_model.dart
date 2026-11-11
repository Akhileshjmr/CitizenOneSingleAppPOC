import '../../domain/entities/insurance_category_entity.dart';

class InsuranceCategoriesResponse {
  final ChMessageModel? chMessage;
  final List<InsuranceCategoryModel> categories;

  InsuranceCategoriesResponse({
    this.chMessage,
    required this.categories,
  });

  factory InsuranceCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return InsuranceCategoriesResponse(
      chMessage: json['chMessage'] != null
          ? ChMessageModel.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((c) => InsuranceCategoryModel.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ChMessageModel {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool isError;
  final String? subject;

  ChMessageModel({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError = false,
    this.subject,
  });

  factory ChMessageModel.fromJson(Map<String, dynamic> json) {
    return ChMessageModel(
      code: json['code'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      dispType: json['dispType'] as String?,
      isError: json['isError'] as bool? ?? false,
      subject: json['subject'] as String?,
    );
  }
}

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
              ?.map((s) => InsuranceSubCategoryModel.fromJson(s as Map<String, dynamic>))
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
