import '../../data/repository/citizen_repository.dart';
import '../entities/citizen_service_entity.dart';

class GetCitizenServicesUseCase {
  final CitizenRepository repository;

  GetCitizenServicesUseCase(this.repository);

  Future<List<CitizenServiceEntity>> call() {
    return repository.getServices();
  }
}
