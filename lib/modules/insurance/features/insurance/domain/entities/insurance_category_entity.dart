class InsuranceCategoryEntity {
  final String code;
  final String name;
  final String? desc;
  final String? logo;
  final List<InsuranceSubCategoryEntity> subCategories;

  const InsuranceCategoryEntity({
    required this.code,
    required this.name,
    this.desc,
    this.logo,
    required this.subCategories,
  });
}

class InsuranceSubCategoryEntity {
  final String code;
  final String name;
  final String? desc;
  final String? logo;

  const InsuranceSubCategoryEntity({
    required this.code,
    required this.name,
    this.desc,
    this.logo,
  });
}
