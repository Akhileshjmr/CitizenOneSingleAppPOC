import 'agent_task_entity.dart';
import 'agent_collection_entity.dart';

class AgentDashboardEntity {
  final String agentName;
  final String agentCode;
  final double totalCollectionsToday;
  final int pendingTasksCount;
  final int activeCustomersCount;
  final double commissionEarned;
  final List<AgentTaskEntity> recentTasks;
  final List<AgentCollectionEntity> recentCollections;

  const AgentDashboardEntity({
    required this.agentName,
    required this.agentCode,
    required this.totalCollectionsToday,
    required this.pendingTasksCount,
    required this.activeCustomersCount,
    required this.commissionEarned,
    required this.recentTasks,
    required this.recentCollections,
  });
}

