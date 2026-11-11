import 'package:citizenone_app/features/agent/customers/domain/entities/agent_customer_entity.dart';
import 'package:citizenone_app/features/agent/customers/domain/repositories/agent_customers_repository.dart';

class GetAgentCustomersUseCase {
  final AgentCustomersRepository _repository;

  const GetAgentCustomersUseCase(this._repository);

  Future<List<AgentCustomerEntity>> call() => _repository.getAssignedCustomers();
}
