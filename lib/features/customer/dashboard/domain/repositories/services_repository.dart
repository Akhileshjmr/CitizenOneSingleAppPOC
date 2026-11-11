import 'package:citizenone_app/features/customer/dashboard/domain/entities/service_entity.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';

abstract class ServicesRepository {
  Future<List<ServiceEntity>> getServices(UserRole role);
}
