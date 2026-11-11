import 'package:citizenone_app/features/agent/tasks/domain/entities/agent_task_detail_entity.dart';

abstract class AgentTasksRepository {
  Future<List<AgentTaskDetailEntity>> getAllTasks();
  Future<bool> markTaskComplete(String id);
}
