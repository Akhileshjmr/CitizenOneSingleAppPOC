import '../entities/agent_task_entity.dart';
import '../repositories/agent_repository.dart';

class GetAgentTasksUseCase {
  final AgentRepository repository;

  GetAgentTasksUseCase(this.repository);

  Future<List<AgentTaskEntity>> call({AgentTaskStatus? status}) {
    return repository.getTasks(status: status);
  }
}

class UpdateTaskStatusUseCase {
  final AgentRepository repository;

  UpdateTaskStatusUseCase(this.repository);

  Future<AgentTaskEntity> call(String taskId, AgentTaskStatus newStatus) {
    return repository.updateTaskStatus(taskId, newStatus);
  }
}

