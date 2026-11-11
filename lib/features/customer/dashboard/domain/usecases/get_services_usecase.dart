import 'package:citizenone_app/features/customer/dashboard/domain/entities/service_entity.dart';
import 'package:citizenone_app/features/customer/dashboard/domain/repositories/services_repository.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';

class GetServicesUseCase {
  final ServicesRepository _repository;

  GetServicesUseCase(this._repository);

  Future<List<ServiceEntity>> call(UserRole role) {
    return _repository.getServices(role);
  }
}
