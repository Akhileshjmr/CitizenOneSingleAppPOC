import 'package:citizenone_app/features/customer/services/domain/entities/service_category.dart';

abstract class ServiceRepository {
  Future<List<ServiceCategory>> getAvailableServices();
}
