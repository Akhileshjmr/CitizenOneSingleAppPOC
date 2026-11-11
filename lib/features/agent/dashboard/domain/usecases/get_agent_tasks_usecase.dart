import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_task_entity.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/repositories/agent_dashboard_repository.dart';

/// Use case: Fetch the agent's pending tasks.
/// Single responsibility — one action per use case (ISP).
class GetAgentTasksUseCase {
  final AgentDashboardRepository _repository;

  GetAgentTasksUseCase(this._repository);

  Future<List<AgentTaskEntity>> call() {
    return _repository.getPendingTasks();
  }
}
