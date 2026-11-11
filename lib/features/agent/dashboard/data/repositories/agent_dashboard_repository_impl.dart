import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_task_entity.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_insight_entity.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/repositories/agent_dashboard_repository.dart';

/// Concrete implementation of [AgentDashboardRepository].
/// Uses mock/local data — swap with a remote DataSource when the API is ready.
class AgentDashboardRepositoryImpl implements AgentDashboardRepository {
  @override
  Future<List<AgentTaskEntity>> getPendingTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTasks;
  }

  @override
  Future<List<AgentInsightEntity>> getAiInsights() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockInsights;
  }
}

// ─── Mock data ────────────────────────────────────────────────────────────────

const List<AgentTaskEntity> _mockTasks = [
  AgentTaskEntity(
    id: 'task_1',
    title: '2 New Onboardings',
    subtitle: 'Pending KYC verification in Sector 4',
    type: AgentTaskType.onboarding,
    status: AgentTaskStatus.pending,
  ),
  AgentTaskEntity(
    id: 'task_2',
    title: '1 Collection Nearby',
    subtitle: 'Green Grocers Ltd — ZK 12,000 due',
    type: AgentTaskType.collection,
    status: AgentTaskStatus.pending,
  ),
  AgentTaskEntity(
    id: 'task_3',
    title: 'KYC Review',
    subtitle: 'Mary Banda — documents uploaded',
    type: AgentTaskType.kyc,
    status: AgentTaskStatus.inProgress,
  ),
];

const List<AgentInsightEntity> _mockInsights = [
  AgentInsightEntity(
    id: 'insight_1',
    title: 'High Demand Area',
    description: 'Sector 4 has 15 merchants waiting for onboarding.',
    actionLabel: 'View Map',
    type: AgentInsightType.highDemand,
  ),
  AgentInsightEntity(
    id: 'insight_2',
    title: 'Pending Collections',
    description: '3 merchants have skipped payment this week.',
    actionLabel: 'View List',
    type: AgentInsightType.pendingCollection,
  ),
];
