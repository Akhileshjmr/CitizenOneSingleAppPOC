import '../api/citizen_api.dart';
import '../../domain/entities/citizen_service_entity.dart';

abstract class CitizenRepository {
  Future<List<CitizenServiceEntity>> getServices();
}

class CitizenRepositoryImpl implements CitizenRepository {
  final CitizenApi api;

  CitizenRepositoryImpl(this.api);

  @override
  Future<List<CitizenServiceEntity>> getServices() async {
    return await api.fetchServices();
  }
}
