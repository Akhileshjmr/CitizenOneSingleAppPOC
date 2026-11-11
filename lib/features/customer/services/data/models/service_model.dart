import 'package:citizenone_app/features/customer/services/domain/entities/service_category.dart';

class ServiceModel extends ServiceCategory {
  const ServiceModel({
    required super.id,
    required super.titleKey,
    super.colorHex,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      titleKey: json['titleKey'] as String,
      colorHex: json['colorHex'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'titleKey': titleKey, 'colorHex': colorHex};
  }
}
