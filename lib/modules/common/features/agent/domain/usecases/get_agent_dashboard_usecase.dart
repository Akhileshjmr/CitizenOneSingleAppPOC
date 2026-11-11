import '../entities/agent_dashboard_entity.dart';
import '../repositories/agent_repository.dart';

class GetAgentDashboardUseCase {
  final AgentRepository repository;

  GetAgentDashboardUseCase(this.repository);

  Future<AgentDashboardEntity> call() {
    return repository.getDashboardData();
  }
}

