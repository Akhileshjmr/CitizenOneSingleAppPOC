import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_task_entity.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_insight_entity.dart';

/// Abstract contract for the Agent Dashboard data layer.
/// The Domain layer depends ONLY on this interface (DIP).
abstract class AgentDashboardRepository {
  Future<List<AgentTaskEntity>> getPendingTasks();
  Future<List<AgentInsightEntity>> getAiInsights();
}
