import '../entities/agent_customer_entity.dart';
import '../repositories/agent_repository.dart';

class GetAgentCustomersUseCase {
  final AgentRepository repository;

  GetAgentCustomersUseCase(this.repository);

  Future<List<AgentCustomerEntity>> call({String? query}) {
    return repository.getCustomers(query: query);
  }
}

