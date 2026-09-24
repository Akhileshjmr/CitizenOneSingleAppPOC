import '../../domain/entities/citizen_service_entity.dart';

class CitizenServiceModel extends CitizenServiceEntity {
  const CitizenServiceModel({
    required super.id,
    required super.title,
    required super.category,
    required super.description,
  });

  factory CitizenServiceModel.fromJson(Map<String, dynamic> json) {
    return CitizenServiceModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      description: json['description'] as String? ?? '',
    );
  }
}
