import 'package:citizenone_app/features/agent/tasks/domain/entities/agent_task_detail_entity.dart';
import 'package:citizenone_app/features/agent/tasks/domain/repositories/agent_tasks_repository.dart';

class GetAllTasksUseCase {
  final AgentTasksRepository _repository;

  const GetAllTasksUseCase(this._repository);

  Future<List<AgentTaskDetailEntity>> call() => _repository.getAllTasks();
}
