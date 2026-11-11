import 'package:citizenone_app/features/customer/dashboard/domain/entities/service_entity.dart';

class ServicesState {
  final List<ServiceEntity> services;
  final bool isLoading;

  const ServicesState({
    this.services = const [],
    this.isLoading = false,
  });

  ServicesState copyWith({
    List<ServiceEntity>? services,
    bool? isLoading,
  }) {
    return ServicesState(
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
