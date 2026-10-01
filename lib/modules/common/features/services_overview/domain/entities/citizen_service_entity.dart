import 'package:equatable/equatable.dart';

class CitizenServiceEntity extends Equatable {
  final String id;
  final String title;
  final String category;
  final String description;

  const CitizenServiceEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, category, description];
}
