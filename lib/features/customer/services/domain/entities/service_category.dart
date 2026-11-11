import 'package:equatable/equatable.dart';

class ServiceCategory extends Equatable {
  final String id;
  final String titleKey;
  final String? colorHex;

  const ServiceCategory({
    required this.id,
    required this.titleKey,
    this.colorHex,
  });

  @override
  List<Object?> get props => [id, titleKey, colorHex];
}
