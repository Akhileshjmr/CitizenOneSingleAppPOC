import 'package:citizenone_app/features/customer/services/domain/entities/service_category.dart';
import 'package:citizenone_app/features/customer/services/domain/repositories/service_repository.dart';

class GetServicesUseCase {
  final ServiceRepository repository;

  GetServicesUseCase(this.repository);

  Future<List<ServiceCategory>> execute() {
    return repository.getAvailableServices();
  }
}
