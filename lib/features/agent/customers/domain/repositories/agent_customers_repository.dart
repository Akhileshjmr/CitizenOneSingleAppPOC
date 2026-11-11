import 'package:citizenone_app/features/agent/customers/domain/entities/agent_customer_entity.dart';

abstract class AgentCustomersRepository {
  Future<List<AgentCustomerEntity>> getAssignedCustomers();
}
