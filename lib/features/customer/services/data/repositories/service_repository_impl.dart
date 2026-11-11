import 'package:citizenone_app/features/customer/services/data/datasources/service_data_source.dart';
import 'package:citizenone_app/features/customer/services/domain/entities/service_category.dart';
import 'package:citizenone_app/features/customer/services/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceDataSource dataSource;

  ServiceRepositoryImpl(this.dataSource);

  @override
  Future<List<ServiceCategory>> getAvailableServices() async {
    return await dataSource.getServices();
  }
}
